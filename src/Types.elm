module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import Lamdera exposing (ClientId, SessionId)
import Main as ElmLand
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


type ToFrontend
    = AdminDataRequested { userManagement : UserManagement.Model, backendSyncModel : Sync.BackendSyncModel, subscriptions : Subscriptions.Model }
    | SyncCodeCreated Int
    | SyncCodeUsed { name : String, userId : String, deviceId : String, deviceName : String }
    | ConnectionEstablished
    | EventSyncResult { events : List EventDefinition, lastSyncServerTime : Time.Posix }
    | ListSubscriptionAdded { userId : String, listId : String, timestamp : Time.Posix }
