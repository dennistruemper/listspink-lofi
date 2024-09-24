module Evergreen.V1.Shared.Msg exposing (..)

import Evergreen.V1.Bridge
import Evergreen.V1.Event
import Evergreen.V1.Subscriptions
import Evergreen.V1.Sync
import Evergreen.V1.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V1.UserManagement.Model
        , backendSyncModel : Evergreen.V1.Sync.BackendSyncModel
        , subscriptions : Evergreen.V1.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V1.Bridge.User
    | AddEvent Evergreen.V1.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V1.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
