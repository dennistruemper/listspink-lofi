module Evergreen.V12.Shared.Msg exposing (..)

import Evergreen.V12.Bridge
import Evergreen.V12.Event
import Evergreen.V12.Subscriptions
import Evergreen.V12.Sync
import Evergreen.V12.UserManagement
import Time


type Msg
    = GotAdminData
        { userManagement : Evergreen.V12.UserManagement.Model
        , backendSyncModel : Evergreen.V12.Sync.BackendSyncModel
        , subscriptions : Evergreen.V12.Subscriptions.Model
        }
    | NewUserCreated Evergreen.V12.Bridge.User
    | AddEvent Evergreen.V12.Event.EventDefinition
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
        { events : List Evergreen.V12.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | SidebarToggled Bool
