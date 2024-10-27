module Evergreen.V10.Types exposing (..)

import Evergreen.V10.Bridge
import Evergreen.V10.Event
import Evergreen.V10.Main
import Evergreen.V10.Subscriptions
import Evergreen.V10.Sync
import Evergreen.V10.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V10.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V10.UserManagement.Model
    , subscriptions : Evergreen.V10.Subscriptions.Model
    , syncModel : Evergreen.V10.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V10.Main.Msg


type alias ToBackend =
    Evergreen.V10.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V10.UserManagement.Model
        , backendSyncModel : Evergreen.V10.Sync.BackendSyncModel
        , subscriptions : Evergreen.V10.Subscriptions.Model
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
        { events : List Evergreen.V10.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | ListSubscriptionAdded
        { userId : String
        , listId : String
        , timestamp : Time.Posix
        }
