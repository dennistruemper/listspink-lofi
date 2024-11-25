module Evergreen.V19.Shared.Msg exposing (..)

import Evergreen.V19.Bridge
import Evergreen.V19.Components.Toast
import Evergreen.V19.Event
import Evergreen.V19.Role
import Evergreen.V19.Subscriptions
import Evergreen.V19.Sync
import Evergreen.V19.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V19.UserManagement.Model
        , backendSyncModel : Evergreen.V19.Sync.BackendSyncModel
        , subscriptions : Evergreen.V19.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V19.Bridge.User
    | AddEvent Evergreen.V19.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V19.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V19.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V19.Role.Role
        }
    | SidebarToggled Bool
    | AddToast Evergreen.V19.Components.Toast.Toast
    | ToastMsg Evergreen.V19.Components.Toast.Msg
