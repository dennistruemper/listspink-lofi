module Evergreen.V15.SortedEventList exposing (..)

import Array
import Evergreen.V15.Event


type alias Model =
    Array.Array Evergreen.V15.Event.EventDefinition
