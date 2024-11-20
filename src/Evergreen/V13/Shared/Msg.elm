module Evergreen.V13.Shared.Msg exposing (..)

import Evergreen.V13.Bridge
import Evergreen.V13.Event
import Evergreen.V13.Role
import Evergreen.V13.Subscriptions
import Evergreen.V13.Sync
import Evergreen.V13.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V13.UserManagement.Model
        , backendSyncModel : Evergreen.V13.Sync.BackendSyncModel
        , subscriptions : Evergreen.V13.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V13.Bridge.User
    | AddEvent Evergreen.V13.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V13.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V13.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
