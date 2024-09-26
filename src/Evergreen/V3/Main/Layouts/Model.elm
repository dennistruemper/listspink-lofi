module Evergreen.V3.Main.Layouts.Model exposing (..)

import Evergreen.V3.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V3.Layouts.Scaffold.Model
        }
