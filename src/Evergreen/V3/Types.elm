module Evergreen.V3.Types exposing (..)

import Evergreen.V3.Bridge
import Evergreen.V3.Event
import Evergreen.V3.Main
import Evergreen.V3.Subscriptions
import Evergreen.V3.Sync
import Evergreen.V3.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V3.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V3.UserManagement.Model
    , subscriptions : Evergreen.V3.Subscriptions.Model
    , syncModel : Evergreen.V3.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V3.Main.Msg


type alias ToBackend =
    Evergreen.V3.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V3.UserManagement.Model
        , backendSyncModel : Evergreen.V3.Sync.BackendSyncModel
        , subscriptions : Evergreen.V3.Subscriptions.Model
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
        { events : List Evergreen.V3.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
