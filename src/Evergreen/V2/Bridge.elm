module Evergreen.V2.Bridge exposing (..)

import Evergreen.V2.Event
import Evergreen.V2.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V2.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V2.Event.EventDefinition
    | UseSyncCode
        { code : String
        , deviceId : String
        , deviceName : String
        }
    | RequestNewEvents Time.Posix
