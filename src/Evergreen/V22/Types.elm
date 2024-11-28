module Evergreen.V22.Types exposing (..)

import Evergreen.V22.Bridge
import Evergreen.V22.Event
import Evergreen.V22.Main
import Evergreen.V22.Role
import Evergreen.V22.Subscriptions
import Evergreen.V22.Sync
import Evergreen.V22.UserManagement
import Lamdera
import Time


type alias FrontendModel =
    Evergreen.V22.Main.Model


type alias BackendModel =
    { userManagement : Evergreen.V22.UserManagement.Model
    , subscriptions : Evergreen.V22.Subscriptions.Model
    , syncModel : Evergreen.V22.Sync.BackendSyncModel
    }


type alias FrontendMsg =
    Evergreen.V22.Main.Msg


type alias ToBackend =
    Evergreen.V22.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime Lamdera.SessionId Lamdera.ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String Lamdera.SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type AdminResponse
    = UsersResponse
        { users : List Evergreen.V22.Bridge.UserData
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
        , roles : List Evergreen.V22.Role.Role
        }
    | ConnectionEstablished
    | NotAuthenticated
    | EventSyncResult
        { events : List Evergreen.V22.Event.EventDefinition
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
        , roles : List Evergreen.V22.Role.Role
        }
