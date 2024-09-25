module Evergreen.V2.SortedEventList exposing (..)

import Array
import Evergreen.V2.Event


type alias Model =
    Array.Array Evergreen.V2.Event.EventDefinition
