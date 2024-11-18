module Backend exposing (..)

import Bridge exposing (..)
import Dict exposing (Dict)
import Event
import EventMetadataHelper
import Html
import Lamdera exposing (ClientId, SessionId)
import Main.Pages.Msg
import Pages.Share.ListId_
import Random
import Subscriptions
import Sync
import Task
import Time
import Types exposing (BackendModel, BackendMsg(..), ToFrontend(..))
import UserManagement


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Lamdera.onConnect OnConnect
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { userManagement = UserManagement.init
      , subscriptions = Subscriptions.init
      , syncModel = Sync.initBackend
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update backendMsg model =
    case backendMsg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        OnConnect sid cid ->
            ( model, Cmd.none )

        SyncCodeForUserCreated userId sessionId now syncCode ->
            ( { model | userManagement = UserManagement.startSyncForUser sessionId now (String.fromInt syncCode) model.userManagement }
            , Lamdera.sendToFrontend sessionId <|
                SyncCodeCreated syncCode
            )

        FromFrontendWithTime sessionId clientId msg now ->
            let
                userData =
                    UserManagement.getUserForSession sessionId model.userManagement
            in
            case userData of
                Nothing ->
                    case msg of
                        NewUser newUserData ->
                            handleHello now newUserData model sessionId

                        UseSyncCode data ->
                            let
                                result =
                                    UserManagement.useSyncCode sessionId { code = data.code, deviceId = data.deviceId, deviceName = data.deviceName, now = now } model.userManagement

                                cmd =
                                    case result.user of
                                        Nothing ->
                                            Cmd.none

                                        Just resultUserData ->
                                            Cmd.batch
                                                [ Lamdera.sendToFrontend sessionId <|
                                                    SyncCodeUsed { name = resultUserData.name, userId = resultUserData.userId, deviceId = data.deviceId, deviceName = data.deviceName }
                                                , Lamdera.sendToFrontend sessionId <| ConnectionEstablished
                                                ]
                            in
                            ( { model | userManagement = result.newModel }
                            , cmd
                            )

                        ReconnectUser data ->
                            ( { model | userManagement = UserManagement.reconnectUserOnDevice sessionId data now model.userManagement }, Lamdera.sendToFrontend sessionId <| ConnectionEstablished )

                        -- Do not handle other messages for unknown user session
                        _ ->
                            ( model, Cmd.none )

                Just user ->
                    case msg of
                        RequestAdminData ->
                            ( model
                            , Lamdera.sendToFrontend sessionId <|
                                AdminDataRequested { userManagement = model.userManagement, backendSyncModel = model.syncModel, subscriptions = model.subscriptions }
                            )

                        NewUser newUserData ->
                            handleHello now newUserData model sessionId

                        GenerateSyncCode ->
                            ( model
                            , Random.generate (SyncCodeForUserCreated user.userId sessionId now) <| Random.int 100000 999999
                            )

                        UseSyncCode code ->
                            -- already a user, do nothing
                            ( model, Cmd.none )

                        ReconnectUser data ->
                            -- already connected, do nothing
                            ( model, Lamdera.sendToFrontend sessionId <| ConnectionEstablished )

                        RequestNewEvents lastSyncServerTime ->
                            let
                                events =
                                    Sync.getNewEventsForUser sessionId lastSyncServerTime model.subscriptions model.userManagement model.syncModel
                            in
                            ( model, Lamdera.sendToFrontend sessionId <| EventSyncResult { events = events, lastSyncServerTime = now } )

                        EventAdded event ->
                            let
                                newSubscriptions =
                                    Subscriptions.addSubscription { userId = Event.getUserId event, aggregateId = Event.getAggregateId event } model.subscriptions

                                newSyncModel =
                                    Sync.addEventToBackend event now newSubscriptions model.userManagement model.syncModel

                                commands =
                                    newSyncModel.subscribedSessions
                                        |> List.map .sessionId
                                        |> List.map (\session -> Lamdera.sendToFrontend session <| EventSyncResult { events = [ event ], lastSyncServerTime = now })

                                -- TODO "Send events to connected clients"
                            in
                            ( { model | syncModel = newSyncModel.newBackendModel, subscriptions = newSubscriptions }, Cmd.batch commands )

                        RequestListSubscription data ->
                            let
                                newSubscriptions =
                                    Subscriptions.addSubscription { userId = user.userId, aggregateId = data.listId } model.subscriptions

                                cmd =
                                    if newSubscriptions /= model.subscriptions then
                                        Lamdera.sendToFrontend sessionId <| ListSubscriptionAdded { userId = user.userId, listId = data.listId, timestamp = now }

                                    else
                                        Lamdera.sendToFrontend sessionId <| ListSubscriptionFailed
                            in
                            ( { model | subscriptions = newSubscriptions }
                            , cmd
                            )

                        ReloadAllForAggregate data ->
                            let
                                events =
                                    Sync.getEventsForAggregateId data.aggregateId model.syncModel |> List.map .event
                            in
                            ( model, Lamdera.sendToFrontend sessionId <| EventSyncResult { events = events, lastSyncServerTime = now } )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    ( model, Task.perform (FromFrontendWithTime sessionId clientId msg) Time.now )


handleHello : Time.Posix -> Bridge.User -> Model -> String -> ( Model, Cmd BackendMsg )
handleHello now user model sessionId =
    case user of
        -- new Unknown User is no useful information
        Unknown ->
            ( model, Cmd.none )

        UserOnDevice userData ->
            let
                newModel =
                    { model
                        | userManagement =
                            UserManagement.addUser sessionId userData now model.userManagement
                    }
            in
            ( newModel, Lamdera.sendToFrontend sessionId <| ConnectionEstablished )


addDataToUser : Bridge.UserOnDeviceData -> Dict String UserData -> Dict String UserData
addDataToUser newUserData users =
    let
        user =
            Dict.get newUserData.userId users
    in
    case user of
        Nothing ->
            Dict.insert newUserData.userId
                { name = newUserData.userName
                , devices =
                    [ { deviceId = newUserData.deviceId, name = newUserData.deviceName }
                    ]
                , userId = newUserData.userId
                }
                users

        Just oldData ->
            Dict.insert newUserData.userId
                { name = oldData.name
                , devices = { deviceId = newUserData.deviceId, name = newUserData.deviceName } :: oldData.devices
                , userId = oldData.userId
                }
                users
