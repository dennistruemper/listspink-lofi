module Evergreen.V10.SortedEventList exposing (..)

import Array
import Evergreen.V10.Event


type alias Model =
    Array.Array Evergreen.V10.Event.EventDefinition
