module Evergreen.V22.Bridge exposing (..)

import Evergreen.V22.Event
import Evergreen.V22.UserManagement
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
    Evergreen.V22.UserManagement.UserOnDeviceData


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
    | EventAdded Evergreen.V22.Event.EventDefinition
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
