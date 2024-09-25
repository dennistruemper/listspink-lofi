module Evergreen.V2.Types exposing (..)

import Evergreen.V2.Bridge
import Evergreen.V2.Event
import Evergreen.V2.Main
import Evergreen.V2.Subscriptions
import Evergreen.V2.Sync
import Evergreen.V2.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V2.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V2.UserManagement.Model
    , subscriptions : Evergreen.V2.Subscriptions.Model
    , syncModel : Evergreen.V2.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V2.Main.Msg


type alias ToBackend =
    Evergreen.V2.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested
        { userManagement : Evergreen.V2.UserManagement.Model
        , backendSyncModel : Evergreen.V2.Sync.BackendSyncModel
        , subscriptions : Evergreen.V2.Subscriptions.Model
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
        { events : List Evergreen.V2.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
