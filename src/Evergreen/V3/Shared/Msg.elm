module Evergreen.V3.Shared.Msg exposing (..)

import Evergreen.V3.Bridge
import Evergreen.V3.Event
import Evergreen.V3.Subscriptions
import Evergreen.V3.Sync
import Evergreen.V3.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V3.UserManagement.Model
        , backendSyncModel : Evergreen.V3.Sync.BackendSyncModel
        , subscriptions : Evergreen.V3.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V3.Bridge.User
    | AddEvent Evergreen.V3.Event.EventDefinition
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
        { events : List Evergreen.V3.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
