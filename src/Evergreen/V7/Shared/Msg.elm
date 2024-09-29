module Evergreen.V7.Shared.Msg exposing (..)

import Evergreen.V7.Bridge
import Evergreen.V7.Event
import Evergreen.V7.Subscriptions
import Evergreen.V7.Sync
import Evergreen.V7.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V7.UserManagement.Model
        , backendSyncModel : Evergreen.V7.Sync.BackendSyncModel
        , subscriptions : Evergreen.V7.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V7.Bridge.User
    | AddEvent Evergreen.V7.Event.EventDefinition
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
        { events : List Evergreen.V7.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
