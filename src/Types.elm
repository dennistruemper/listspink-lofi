module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import Lamdera exposing (ClientId, SessionId)
import Main as ElmLand
import Role exposing (Role)
import Subscriptions
import Sync
import Time
import Url exposing (Url)
import UserManagement


type alias FrontendModel =
    ElmLand.Model


type alias BackendModel =
    { userManagement : UserManagement.Model
    , subscriptions : Subscriptions.Model
    , syncModel : Sync.BackendSyncModel
    }


type alias FrontendMsg =
    ElmLand.Msg


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = OnConnect SessionId ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime SessionId ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated String SessionId Time.Posix Int
    | AdminJobTick Time.Posix


type ToFrontend
    = AdminDataResponse AdminResponse
    | NoOp
    | SyncCodeCreated Int
    | SyncCodeUsed { name : String, userId : String, deviceId : String, deviceName : String, roles : List Role }
    | ConnectionEstablished
    | NotAuthenticated
    | EventSyncResult { events : List EventDefinition, lastSyncServerTime : Time.Posix }
    | ListSubscriptionAdded { userId : String, listId : String, timestamp : Time.Posix }
    | ListSubscriptionFailed
    | UserRolesUpdated { userId : String, roles : List Role }


type AdminResponse
    = UsersResponse { users : List Bridge.UserData }
    | UserDeleted String
