module Evergreen.V20.SortedEventList exposing (..)

import Array
import Evergreen.V20.Event


type alias Model =
    Array.Array Evergreen.V20.Event.EventDefinition
