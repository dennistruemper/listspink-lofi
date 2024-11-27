module Evergreen.V20.Types exposing (..)

import Evergreen.V20.Bridge
import Evergreen.V20.Event
import Evergreen.V20.Main
import Evergreen.V20.Role
import Evergreen.V20.Subscriptions
import Evergreen.V20.Sync
import Evergreen.V20.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V20.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V20.UserManagement.Model
    , subscriptions : Evergreen.V20.Subscriptions.Model
    , syncModel : Evergreen.V20.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V20.Main.Msg


type alias ToBackend =
    Evergreen.V20.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type AdminResponse
    = UsersResponse
        { users : List Evergreen.V20.Bridge.UserData
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
        , roles : List Evergreen.V20.Role.Role
        }
    | ConnectionEstablished
    | NotAuthenticated
    | EventSyncResult
        { events : List Evergreen.V20.Event.EventDefinition
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
        , roles : List Evergreen.V20.Role.Role
        }
