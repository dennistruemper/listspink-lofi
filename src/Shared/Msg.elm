module Shared.Msg exposing (Msg(..))

import Bridge
import Dict exposing (Dict)
import Primitives exposing (SessionId, UserId)
import UserManagement


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type Msg
    = GotAdminData { userManagement : UserManagement.Model }
    | NewUserCreated Bridge.User
    | GotSyncCode Int
    | GotUserData { name : String, userId : UserId, deviceId : String, deviceName : String }
    | GotMessageFromJs String
