module Evergreen.V10.Bridge exposing (..)

import Evergreen.V10.Event
import Evergreen.V10.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V10.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V10.Event.EventDefinition
    | UseSyncCode
        { code : String
        , deviceId : String
        , deviceName : String
        }
    | RequestNewEvents Time.Posix
    | RequestListSubscription
        { listId : String
        }
    | ReloadAllForAggregate
        { aggregateId : String
        }
