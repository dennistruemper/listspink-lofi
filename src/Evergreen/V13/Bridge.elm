module Evergreen.V13.Bridge exposing (..)

import Evergreen.V13.Event
import Evergreen.V13.UserManagement
import Time


type alias UserOnDeviceData =
    Evergreen.V13.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V13.Event.EventDefinition
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
