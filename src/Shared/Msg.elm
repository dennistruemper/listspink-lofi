module Shared.Msg exposing (Msg(..))

import Bridge
import Components.Toast
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import Role exposing (Role)
import Status exposing (Status)
import Subscriptions
import Sync
import Time


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type Msg
    = NewUserCreated Bridge.User
    | AddEvent EventDefinition
    | GotSyncCode Int
    | GotUserData { name : String, userId : String, deviceId : String, deviceName : String, roles : List Role }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult { events : List EventDefinition, lastSyncServerTime : Time.Posix }
    | UserRolesUpdated { userId : String, roles : List Role }
    | SidebarToggled Bool
    | AddToast Components.Toast.Toast
    | ToastMsg Components.Toast.Msg
    | NotAuthenticated
    | StatusResponse Status String
