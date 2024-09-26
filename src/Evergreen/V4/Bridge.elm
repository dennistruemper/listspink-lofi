module Evergreen.V4.Bridge exposing (..)

import Evergreen.V4.Event
import Evergreen.V4.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V4.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V4.Event.EventDefinition
    | UseSyncCode
        { code : String
        , deviceId : String
        , deviceName : String
        }
    | RequestNewEvents Time.Posix
