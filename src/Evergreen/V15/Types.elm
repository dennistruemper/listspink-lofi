module Evergreen.V15.Types exposing (..)

import Evergreen.V15.Bridge
import Evergreen.V15.Event
import Evergreen.V15.Main
import Evergreen.V15.Role
import Evergreen.V15.Subscriptions
import Evergreen.V15.Sync
import Evergreen.V15.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V15.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V15.UserManagement.Model
    , subscriptions : Evergreen.V15.Subscriptions.Model
    , syncModel : Evergreen.V15.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V15.Main.Msg


type alias ToBackend =
    Evergreen.V15.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V15.UserManagement.Model
        , backendSyncModel : Evergreen.V15.Sync.BackendSyncModel
        , subscriptions : Evergreen.V15.Subscriptions.Model
        }
    | SyncCodeCreated Int
    | SyncCodeUsed
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V15.Role.Role
        }
    | ConnectionEstablished
    | EventSyncResult
        { events : List Evergreen.V15.Event.EventDefinition
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
        , roles : List Evergreen.V15.Role.Role
        }
