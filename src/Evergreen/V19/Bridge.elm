module Evergreen.V19.Bridge exposing (..)

import Evergreen.V19.Event
import Evergreen.V19.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V19.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V19.Event.EventDefinition
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
