module UserManagement exposing (Model, UserData, UserOnDeviceData, addDeviceDataToUser, addUser, canselSync, getOtherSessionsForUser, getSessionCount, getSyncCodeForUser, getUserForSession, init, reconnectUserOnDevice, startSyncForUser, useSyncCode)

import Dict exposing (Dict)
import Primitives exposing (DeviceId, SessionId, UserId)
import Time


type alias Model =
    { userSessions : Dict SessionId SessionData
    , users : Dict UserId UserData
    }


type alias SessionData =
    { userId : UserId, deviceId : DeviceId, sessionId : SessionId, createdAt : Time.Posix }


type alias UserData =
    { name : String
    , devices : List { deviceId : DeviceId, name : String }
    , userId : UserId
    , syncInProgress : Maybe SyncData
    }


type alias SyncData =
    { startedAt : Time.Posix
    , code : String
    }


type alias UserOnDeviceData =
    { userId : UserId, deviceId : DeviceId, deviceName : String, userName : String }


init : Model
init =
    { userSessions = Dict.empty
    , users = Dict.empty
    }


getUserForSession : SessionId -> Model -> Maybe UserData
getUserForSession sessionId model =
    Dict.get sessionId model.userSessions
        |> Maybe.andThen (\sessionData -> Dict.get sessionData.userId model.users)


getSessionCount : Model -> Int
getSessionCount model =
    Dict.size model.userSessions


addUser : SessionId -> UserOnDeviceData -> Time.Posix -> Model -> Model
addUser sessionId newUserData now model =
    let
        userOrSessionExists =
            (Dict.get sessionId model.userSessions |> Maybe.andThen (\_ -> Just True) |> Maybe.withDefault False)
                || (Dict.get newUserData.userId model.users |> Maybe.andThen (\_ -> Just True) |> Maybe.withDefault False)

        newSessions =
            Dict.insert sessionId
                { userId = newUserData.userId, createdAt = now, deviceId = newUserData.deviceId, sessionId = sessionId }
                model.userSessions

        newUsers =
            Dict.insert newUserData.userId
                { name = newUserData.userName
                , devices = [ { deviceId = newUserData.deviceId, name = newUserData.deviceName } ]
                , userId = newUserData.userId
                , syncInProgress = Nothing
                }
                model.users
    in
    if userOrSessionExists then
        model

    else
        { model | users = newUsers, userSessions = newSessions }


reconnectUserOnDevice : SessionId -> { userId : UserId, deviceId : DeviceId } -> Time.Posix -> Model -> Model
reconnectUserOnDevice sessionId { userId, deviceId } now model =
    let
        user =
            Dict.get userId model.users

        newSessions =
            case user of
                Nothing ->
                    model.userSessions

                Just userData ->
                    let
                        oldSessionId =
                            List.filter (\session -> session.deviceId == deviceId) (Dict.values model.userSessions)
                                |> List.map .sessionId
                                |> List.head

                        hasMatchingDeviceForUser =
                            List.any (\device -> device.deviceId == deviceId) userData.devices
                    in
                    case ( hasMatchingDeviceForUser, oldSessionId ) of
                        ( True, Just oldDeviceSessionId ) ->
                            if oldDeviceSessionId == sessionId then
                                model.userSessions

                            else
                                model.userSessions
                                    |> Dict.insert sessionId { userId = userId, createdAt = now, deviceId = deviceId, sessionId = sessionId }
                                    |> Dict.remove oldDeviceSessionId

                        _ ->
                            model.userSessions
    in
    { model | userSessions = newSessions }


addDeviceDataToUser : SessionId -> UserOnDeviceData -> Time.Posix -> Model -> Model
addDeviceDataToUser sessionId newUserData now model =
    let
        sessionData =
            Dict.get sessionId model.userSessions

        newSessions =
            case sessionData of
                Nothing ->
                    Dict.insert sessionId
                        { userId = newUserData.userId, createdAt = now, deviceId = newUserData.deviceId, sessionId = sessionId }
                        model.userSessions

                Just _ ->
                    model.userSessions

        users =
            model.users

        user =
            Dict.get newUserData.userId users

        newUsers =
            case user of
                Nothing ->
                    -- This is just to add to a user, not create a new one
                    users

                Just oldData ->
                    Dict.insert newUserData.userId
                        { name = oldData.name
                        , devices = List.append oldData.devices [ { deviceId = newUserData.deviceId, name = newUserData.deviceName } ]
                        , userId = newUserData.userId
                        , syncInProgress = oldData.syncInProgress
                        }
                        users
    in
    { model | users = newUsers, userSessions = newSessions }


getOtherSessionsForUser : SessionId -> Model -> List SessionId
getOtherSessionsForUser sessionId model =
    let
        sessionData =
            Dict.get sessionId model.userSessions

        userId =
            Maybe.map .userId sessionData

        otherSessions =
            case userId of
                Nothing ->
                    []

                Just uid ->
                    Dict.toList model.userSessions
                        |> List.filterMap
                            (\( sid, data ) ->
                                if data.userId == uid && sid /= sessionId then
                                    Just sid

                                else
                                    Nothing
                            )
    in
    otherSessions


startSyncForUser : SessionId -> Time.Posix -> String -> Model -> Model
startSyncForUser sessionId now code model =
    let
        maybeUser =
            getUserForSession sessionId model

        newUsers =
            case maybeUser of
                Nothing ->
                    model.users

                Just user ->
                    Dict.insert user.userId
                        { user | syncInProgress = Just { startedAt = now, code = code } }
                        model.users
    in
    { model | users = newUsers }


getSyncCodeForUser : SessionId -> Model -> Maybe String
getSyncCodeForUser sessionId model =
    getUserForSession sessionId model
        |> Maybe.andThen .syncInProgress
        |> Maybe.map .code


getUserDataBySyncCode : String -> Model -> Maybe UserData
getUserDataBySyncCode code model =
    Dict.values model.users
        |> List.filter
            (\user ->
                (user.syncInProgress
                    |> Maybe.map .code
                )
                    == Just code
            )
        |> List.head


useSyncCode : SessionId -> { code : String, deviceId : String, deviceName : String, now : Time.Posix } -> Model -> { newModel : Model, user : Maybe UserData }
useSyncCode sessionId data model =
    case getUserDataBySyncCode data.code model of
        Nothing ->
            { newModel = model, user = Nothing }

        Just user ->
            { newModel =
                { model
                    | users =
                        Dict.insert user.userId
                            { user | syncInProgress = Nothing, devices = user.devices ++ [ { deviceId = data.deviceId, name = data.deviceName } ] }
                            model.users
                    , userSessions =
                        Dict.insert sessionId
                            { userId = user.userId, createdAt = data.now, deviceId = data.deviceId, sessionId = sessionId }
                            model.userSessions
                }
            , user = Just user
            }


canselSync : SessionId -> Model -> Model
canselSync sessionId model =
    let
        maybeUser =
            getUserForSession sessionId model

        newUsers =
            case maybeUser of
                Nothing ->
                    model.users

                Just user ->
                    Dict.insert user.userId
                        { user | syncInProgress = Nothing }
                        model.users
    in
    { model | users = newUsers }
