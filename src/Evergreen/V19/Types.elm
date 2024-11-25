module Evergreen.V19.Types exposing (..)

import Evergreen.V19.Bridge
import Evergreen.V19.Event
import Evergreen.V19.Main
import Evergreen.V19.Role
import Evergreen.V19.Subscriptions
import Evergreen.V19.Sync
import Evergreen.V19.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V19.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V19.UserManagement.Model
    , subscriptions : Evergreen.V19.Subscriptions.Model
    , syncModel : Evergreen.V19.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V19.Main.Msg


type alias ToBackend =
    Evergreen.V19.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V19.UserManagement.Model
        , backendSyncModel : Evergreen.V19.Sync.BackendSyncModel
        , subscriptions : Evergreen.V19.Subscriptions.Model
        }
    | SyncCodeCreated Int
    | SyncCodeUsed
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V19.Role.Role
        }
    | ConnectionEstablished
    | EventSyncResult
        { events : List Evergreen.V19.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | ListSubscriptionAdded
        { userId : String
        , listId : String
        , timestamp : Time.Posix
        }
    | ListSubscriptionFailed
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V19.Role.Role
        }
