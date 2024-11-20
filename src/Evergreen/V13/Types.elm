module Evergreen.V13.Types exposing (..)

import Evergreen.V13.Bridge
import Evergreen.V13.Event
import Evergreen.V13.Main
import Evergreen.V13.Role
import Evergreen.V13.Subscriptions
import Evergreen.V13.Sync
import Evergreen.V13.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V13.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V13.UserManagement.Model
    , subscriptions : Evergreen.V13.Subscriptions.Model
    , syncModel : Evergreen.V13.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V13.Main.Msg


type alias ToBackend =
    Evergreen.V13.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V13.UserManagement.Model
        , backendSyncModel : Evergreen.V13.Sync.BackendSyncModel
        , subscriptions : Evergreen.V13.Subscriptions.Model
        }
    | SyncCodeCreated Int
    | SyncCodeUsed
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V13.Role.Role
        }
    | ConnectionEstablished
    | EventSyncResult
        { events : List Evergreen.V13.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | ListSubscriptionAdded
        { userId : String
        , listId : String
        , timestamp : Time.Posix
        }
    | ListSubscriptionFailed
