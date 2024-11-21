module Evergreen.V15.Bridge exposing (..)

import Evergreen.V15.Event
import Evergreen.V15.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V15.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V15.Event.EventDefinition
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
