module Evergreen.V4.SortedEventList exposing (..)

import Array
import Evergreen.V4.Event


type alias Model =
    Array.Array Evergreen.V4.Event.EventDefinition
