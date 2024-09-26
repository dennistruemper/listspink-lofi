module Evergreen.V3.SortedEventList exposing (..)

import Array
import Evergreen.V3.Event


type alias Model =
    Array.Array Evergreen.V3.Event.EventDefinition
