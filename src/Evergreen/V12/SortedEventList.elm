module Evergreen.V12.SortedEventList exposing (..)

import Array
import Evergreen.V12.Event


type alias Model =
    Array.Array Evergreen.V12.Event.EventDefinition
