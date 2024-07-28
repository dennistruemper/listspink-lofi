module Bridge exposing (..)

import Json.Encode
import Primitives exposing (DeviceId, UserId)
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
        ]


type alias UserData =
    { name : String, devices : List { deviceId : DeviceId, name : String }, userId : UserId }


type ToBackend
    = NewUser User
    | ReconnectUser { userId : UserId, deviceId : DeviceId }
    | RequestAdminData
    | GenerateSyncCode
    | UseSyncCode { code : String, deviceId : DeviceId, deviceName : String }
