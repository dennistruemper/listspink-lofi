module Bridge exposing (..)

import Event exposing (EventDefinition)
import Json.Encode
import Role
import Time
import UserManagement


type alias UserOnDeviceData =
    UserManagement.UserOnDeviceData


type User
    = Unknown
    | UserOnDevice UserOnDeviceData


encodeUser : User -> Json.Encode.Value
encodeUser user =
    case user of
        Unknown ->
            Json.Encode.object [ ( "userId", Json.Encode.string "Unknown" ) ]

        UserOnDevice data ->
            encodeUserOnDeviceData data


encodeUserOnDeviceData : UserOnDeviceData -> Json.Encode.Value
encodeUserOnDeviceData data =
    Json.Encode.object
        [ ( "userId", Json.Encode.string data.userId )
        , ( "deviceId", Json.Encode.string data.deviceId )
        , ( "deviceName", Json.Encode.string data.deviceName )
        , ( "userName", Json.Encode.string data.userName )
        , ( "roles", Json.Encode.list Role.encode data.roles )
        ]


type alias UserData =
    { name : String, devices : List { deviceId : String, name : String }, userId : String }


type AdminRequestType
    = UsersRequest
    | DeleteUser String


type ToBackend
    = NewUser User
    | ReconnectUser { userId : String, deviceId : String }
    | AdminRequest AdminRequestType
    | GenerateSyncCode
    | EventAdded EventDefinition
    | UseSyncCode { code : String, deviceId : String, deviceName : String }
    | RequestNewEvents Time.Posix
    | RequestListSubscription { listId : String }
    | ReloadAllForAggregate { aggregateId : String }
    | UnsubscribeFromList { listId : String }
    | NoOp -- for migration only
