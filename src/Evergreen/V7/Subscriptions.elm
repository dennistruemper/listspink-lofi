module Evergreen.V7.Subscriptions exposing (..)

import Array


type alias Subscription =
    { userId : String
    , aggregateId : String
    }


type alias Model =
    { subscriptions : Array.Array Subscription
    }
