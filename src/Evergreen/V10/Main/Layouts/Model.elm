module Evergreen.V10.Main.Layouts.Model exposing (..)

import Evergreen.V10.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V10.Layouts.Scaffold.Model
        }
