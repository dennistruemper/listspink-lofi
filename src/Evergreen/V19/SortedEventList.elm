module Evergreen.V19.SortedEventList exposing (..)

import Array
import Evergreen.V19.Event


type alias Model =
    Array.Array Evergreen.V19.Event.EventDefinition
