module Evergreen.V7.Types exposing (..)

import Evergreen.V7.Bridge
import Evergreen.V7.Event
import Evergreen.V7.Main
import Evergreen.V7.Subscriptions
import Evergreen.V7.Sync
import Evergreen.V7.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V7.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V7.UserManagement.Model
    , subscriptions : Evergreen.V7.Subscriptions.Model
    , syncModel : Evergreen.V7.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V7.Main.Msg


type alias ToBackend =
    Evergreen.V7.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V7.UserManagement.Model
        , backendSyncModel : Evergreen.V7.Sync.BackendSyncModel
        , subscriptions : Evergreen.V7.Subscriptions.Model
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
        { events : List Evergreen.V7.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
