module Evergreen.V7.Main.Layouts.Model exposing (..)

import Evergreen.V7.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V7.Layouts.Scaffold.Model
        }
