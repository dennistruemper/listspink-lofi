module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Lamdera exposing (ClientId, SessionId)
import Main as ElmLand
import Primitives exposing (DeviceId, SessionId, UserId)
import Time
import Url exposing (Url)
import UserManagement


type alias FrontendModel =
    ElmLand.Model


type alias BackendModel =
    { userManagement : UserManagement.Model
    }


type alias FrontendMsg =
    ElmLand.Msg


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = OnConnect SessionId ClientId
    | NoOpBackendMsg
    | FromFrontendWithTime SessionId ClientId ToBackend Time.Posix
    | SyncCodeForUserCreated UserId SessionId Time.Posix Int


type ToFrontend
    = AdminDataRequested { userManagement : UserManagement.Model }
    | SyncCodeCreated Int
    | SyncCodeUsed { name : String, userId : UserId, deviceId : DeviceId, deviceName : String }
