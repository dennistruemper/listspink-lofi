module Evergreen.V13.SortedEventList exposing (..)

import Array
import Evergreen.V13.Event


type alias Model =
    Array.Array Evergreen.V13.Event.EventDefinition
