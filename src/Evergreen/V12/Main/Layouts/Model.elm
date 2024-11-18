module Evergreen.V12.Main.Layouts.Model exposing (..)

import Evergreen.V12.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V12.Layouts.Scaffold.Model
        }
