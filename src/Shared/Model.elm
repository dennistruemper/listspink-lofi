module Shared.Model exposing (Model, NextIds)

import Bridge
import Dict exposing (Dict)
import Primitives exposing (SessionId, UserId)
import UserManagement


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData : { userManagement : UserManagement.Model }
    , user : Maybe Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    }