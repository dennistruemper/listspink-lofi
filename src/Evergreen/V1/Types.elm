module Evergreen.V1.Types exposing (..)

import Evergreen.V1.Bridge
import Evergreen.V1.Event
import Evergreen.V1.Main
import Evergreen.V1.Subscriptions
import Evergreen.V1.Sync
import Evergreen.V1.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V1.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V1.UserManagement.Model
    , subscriptions : Evergreen.V1.Subscriptions.Model
    , syncModel : Evergreen.V1.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V1.Main.Msg


type alias ToBackend =
    Evergreen.V1.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V1.UserManagement.Model
        , backendSyncModel : Evergreen.V1.Sync.BackendSyncModel
        , subscriptions : Evergreen.V1.Subscriptions.Model
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
        { events : List Evergreen.V1.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
