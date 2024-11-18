module Evergreen.V12.Types exposing (..)

import Evergreen.V12.Bridge
import Evergreen.V12.Event
import Evergreen.V12.Main
import Evergreen.V12.Subscriptions
import Evergreen.V12.Sync
import Evergreen.V12.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V12.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V12.UserManagement.Model
    , subscriptions : Evergreen.V12.Subscriptions.Model
    , syncModel : Evergreen.V12.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V12.Main.Msg


type alias ToBackend =
    Evergreen.V12.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V12.UserManagement.Model
        , backendSyncModel : Evergreen.V12.Sync.BackendSyncModel
        , subscriptions : Evergreen.V12.Subscriptions.Model
        }
    | SyncCodeCreated Int
    | SyncCodeUsed
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        }
    | ConnectionEstablished
    | EventSyncResult
        { events : List Evergreen.V12.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | ListSubscriptionAdded
        { userId : String
        , listId : String
        , timestamp : Time.Posix
        }
    | ListSubscriptionFailed
