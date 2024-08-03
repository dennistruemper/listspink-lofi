module Shared.Msg exposing (Msg(..))

import Bridge
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import Subscriptions
import Sync
import Time
import UserManagement


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type Msg
    = GotAdminData { userManagement : UserManagement.Model, backendSyncModel : Sync.BackendSyncModel, subscriptions : Subscriptions.Model }
    | NewUserCreated Bridge.User
    | AddEvent EventDefinition
    | GotSyncCode Int
    | GotUserData { name : String, userId : String, deviceId : String, deviceName : String }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult { events : List EventDefinition, lastSyncServerTime : Time.Posix }
