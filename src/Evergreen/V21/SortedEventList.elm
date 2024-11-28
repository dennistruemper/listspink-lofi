module Evergreen.V21.SortedEventList exposing (..)

import Array
import Evergreen.V21.Event


type alias Model =
    Array.Array Evergreen.V21.Event.EventDefinition
