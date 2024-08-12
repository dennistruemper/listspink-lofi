port module Ports exposing (ToElm(..), decodeMsg, toElm, toJs)

import Bridge
import FrontendSyncModelSerializer
import Json.Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode
import Serialize
import Sync
import UserManagement


type ToElm
    = IdsGenerated IdsGeneratedData
    | UserDataLoaded Bridge.User
    | UserLoggedOut
    | UnknownMessage String
    | FrontendSyncModelDataLoaded (Result String Sync.FrontendSyncModel)


type alias IdsGeneratedData =
    { userId : String, deviceId : String, eventId : String, listId : String, itemId : String }


port toElm : (String -> msg) -> Sub msg


idsGeneratedDataDecoder : Json.Decode.Decoder IdsGeneratedData
idsGeneratedDataDecoder =
    Json.Decode.succeed IdsGeneratedData
        |> Pipeline.required "userId" Json.Decode.string
        |> Pipeline.required "deviceId" Json.Decode.string
        |> Pipeline.required "eventId" Json.Decode.string
        |> Pipeline.required "listId" Json.Decode.string
        |> Pipeline.required "itemId" Json.Decode.string


userDecoder : Json.Decode.Decoder Bridge.User
userDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map Bridge.UserOnDevice userDataDecoder
        , Json.Decode.succeed Bridge.Unknown
        ]


userDataDecoder : Json.Decode.Decoder UserManagement.UserOnDeviceData
userDataDecoder =
    Json.Decode.succeed UserManagement.UserOnDeviceData
        |> Pipeline.required "userId" Json.Decode.string
        |> Pipeline.required "deviceId" Json.Decode.string
        |> Pipeline.required "deviceName" Json.Decode.string
        |> Pipeline.required "userName" Json.Decode.string


decodeMsg : String -> ToElm
decodeMsg json =
    case Json.Decode.decodeString (Json.Decode.field "tag" Json.Decode.string) json of
        Ok "IdsGenerated" ->
            case Json.Decode.decodeString (Json.Decode.field "data" idsGeneratedDataDecoder) json of
                Ok data ->
                    IdsGenerated data

                Err message ->
                    UnknownMessage (formatError "data for IdsGenerated" message)

        Ok "UserDataLoaded" ->
            case Json.Decode.decodeString (Json.Decode.field "data" userDecoder) json of
                Ok user ->
                    UserDataLoaded user

                Err message ->
                    UnknownMessage (formatError "data for UserDataLoaded" message)

        Ok "FrontendSyncModelDataLoaded" ->
            let
                data =
                    Json.Decode.decodeString (Json.Decode.field "data" Json.Decode.string) json
            in
            case data of
                Ok jsonAsString ->
                    FrontendSyncModelDataLoaded (FrontendSyncModelSerializer.deserializeFrontendSyncModel jsonAsString |> Result.mapError (\err -> "err deserializing sync model"))

                Err message ->
                    FrontendSyncModelDataLoaded (Err "error deserializing sync model")

        Ok "LoggedOut" ->
            UserLoggedOut

        Err message ->
            UnknownMessage (formatError "tag" message)

        Ok tagname ->
            UnknownMessage <| "tag is unknown: " ++ tagname


formatError : String -> Json.Decode.Error -> String
formatError field error =
    "Could not decode" ++ field ++ ": " ++ Json.Decode.errorToString error


port toJs : { tag : String, data : Json.Encode.Value } -> Cmd msg
