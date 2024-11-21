module Evergreen.V15.Shared.Msg exposing (..)

import Evergreen.V15.Bridge
import Evergreen.V15.Event
import Evergreen.V15.Role
import Evergreen.V15.Subscriptions
import Evergreen.V15.Sync
import Evergreen.V15.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V15.UserManagement.Model
        , backendSyncModel : Evergreen.V15.Sync.BackendSyncModel
        , subscriptions : Evergreen.V15.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V15.Bridge.User
    | AddEvent Evergreen.V15.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V15.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V15.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V15.Role.Role
        }
    | SidebarToggled Bool
