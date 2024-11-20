module Evergreen.V13.Main.Layouts.Model exposing (..)

import Evergreen.V13.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V13.Layouts.Scaffold.Model
        }
