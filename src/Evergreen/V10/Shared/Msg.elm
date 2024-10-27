module Evergreen.V10.Shared.Msg exposing (..)

import Evergreen.V10.Bridge
import Evergreen.V10.Event
import Evergreen.V10.Subscriptions
import Evergreen.V10.Sync
import Evergreen.V10.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V10.UserManagement.Model
        , backendSyncModel : Evergreen.V10.Sync.BackendSyncModel
        , subscriptions : Evergreen.V10.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V10.Bridge.User
    | AddEvent Evergreen.V10.Event.EventDefinition
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
        { events : List Evergreen.V10.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
