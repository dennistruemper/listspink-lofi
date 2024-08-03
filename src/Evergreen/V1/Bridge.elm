module Evergreen.V1.Bridge exposing (..)

import Evergreen.V1.Event
import Evergreen.V1.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V1.UserManagement.UserOnDeviceData


type User
    = Unknown
    | UserOnDevice UserOnDeviceData


type ToBackend
    = NewUser User
    | ReconnectUser
        { userId : String
        , deviceId : String
        }
    | RequestAdminData
    | GenerateSyncCode
    | EventAdded Evergreen.V1.Event.EventDefinition
    | UseSyncCode
        { code : String
        , deviceId : String
        , deviceName : String
        }
    | RequestNewEvents Time.Posix
