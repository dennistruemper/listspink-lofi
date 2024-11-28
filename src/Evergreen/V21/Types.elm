module Evergreen.V21.Types exposing (..)

import Evergreen.V21.Bridge
import Evergreen.V21.Event
import Evergreen.V21.Main
import Evergreen.V21.Role
import Evergreen.V21.Subscriptions
import Evergreen.V21.Sync
import Evergreen.V21.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V21.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V21.UserManagement.Model
    , subscriptions : Evergreen.V21.Subscriptions.Model
    , syncModel : Evergreen.V21.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V21.Main.Msg


type alias ToBackend =
    Evergreen.V21.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type AdminResponse
    = UsersResponse
        { users : List Evergreen.V21.Bridge.UserData
        }
    | UserDeleted String


type ToFrontend
    = AdminDataResponse AdminResponse
    | NoOp
    | SyncCodeCreated Int
    | SyncCodeUsed
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V21.Role.Role
        }
    | ConnectionEstablished
    | NotAuthenticated
    | EventSyncResult
        { events : List Evergreen.V21.Event.EventDefinition
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
        , roles : List Evergreen.V21.Role.Role
        }
