module Evergreen.V20.Bridge exposing (..)

import Evergreen.V20.Event
import Evergreen.V20.UserManagement
import Time


type alias UserData =
    { name : String
    , devices :
        List
            { deviceId : String
            , name : String
            }
    , userId : String
    }


type alias UserOnDeviceData =
    Evergreen.V20.UserManagement.UserOnDeviceData


type User
    = Unknown
    | UserOnDevice UserOnDeviceData


type AdminRequestType
    = UsersRequest
    | DeleteUser String


type ToBackend
    = NewUser User
    | ReconnectUser
        { userId : String
        , deviceId : String
        }
    | AdminRequest AdminRequestType
    | GenerateSyncCode
    | EventAdded Evergreen.V20.Event.EventDefinition
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
    | NoOp
