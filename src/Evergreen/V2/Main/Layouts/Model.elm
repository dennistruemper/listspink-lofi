module Evergreen.V2.Main.Layouts.Model exposing (..)

import Evergreen.V2.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V2.Layouts.Scaffold.Model
        }
