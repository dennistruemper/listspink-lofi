module Evergreen.V7.SortedEventList exposing (..)

import Array
import Evergreen.V7.Event


type alias Model =
    Array.Array Evergreen.V7.Event.EventDefinition
