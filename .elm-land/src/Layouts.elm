module Layouts exposing (..)

import Layouts.Scaffold


type Layout msg
    = Scaffold Layouts.Scaffold.Props


map : (msg1 -> msg2) -> Layout msg1 -> Layout msg2
map fn layout =
    case layout of
        Scaffold data ->
            Scaffold data
