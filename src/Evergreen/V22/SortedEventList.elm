module Evergreen.V22.SortedEventList exposing (..)

import Array
import Evergreen.V22.Event


type alias Model =
    Array.Array Evergreen.V22.Event.EventDefinition
