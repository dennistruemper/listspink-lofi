module Evergreen.V4.Types exposing (..)

import Evergreen.V4.Bridge
import Evergreen.V4.Event
import Evergreen.V4.Main
import Evergreen.V4.Subscriptions
import Evergreen.V4.Sync
import Evergreen.V4.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V4.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V4.UserManagement.Model
    , subscriptions : Evergreen.V4.Subscriptions.Model
    , syncModel : Evergreen.V4.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V4.Main.Msg


type alias ToBackend =
    Evergreen.V4.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V4.UserManagement.Model
        , backendSyncModel : Evergreen.V4.Sync.BackendSyncModel
        , subscriptions : Evergreen.V4.Subscriptions.Model
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
        { events : List Evergreen.V4.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
