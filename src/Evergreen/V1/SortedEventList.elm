module Evergreen.V1.SortedEventList exposing (..)

import Array
import Evergreen.V1.Event


type alias Model =
    Array.Array Evergreen.V1.Event.EventDefinition
