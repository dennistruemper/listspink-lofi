module Evergreen.V4.Shared.Msg exposing (..)

import Evergreen.V4.Bridge
import Evergreen.V4.Event
import Evergreen.V4.Subscriptions
import Evergreen.V4.Sync
import Evergreen.V4.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V4.UserManagement.Model
        , backendSyncModel : Evergreen.V4.Sync.BackendSyncModel
        , subscriptions : Evergreen.V4.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V4.Bridge.User
    | AddEvent Evergreen.V4.Event.EventDefinition
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
        { events : List Evergreen.V4.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
