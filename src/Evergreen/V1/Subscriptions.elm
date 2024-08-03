module Evergreen.V1.Subscriptions exposing (..)

import Array


type alias Subscription =
    { userId : String
    , aggregateId : String
    }


type alias Model =
    { subscriptions : Array.Array Subscription
    }
