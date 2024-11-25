module Evergreen.V19.Main.Layouts.Model exposing (..)

import Evergreen.V19.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V19.Layouts.Scaffold.Model
        }
