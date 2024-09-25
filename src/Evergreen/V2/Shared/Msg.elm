module Evergreen.V2.Shared.Msg exposing (..)

import Evergreen.V2.Bridge
import Evergreen.V2.Event
import Evergreen.V2.Subscriptions
import Evergreen.V2.Sync
import Evergreen.V2.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V2.UserManagement.Model
        , backendSyncModel : Evergreen.V2.Sync.BackendSyncModel
        , subscriptions : Evergreen.V2.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V2.Bridge.User
    | AddEvent Evergreen.V2.Event.EventDefinition
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
        { events : List Evergreen.V2.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
