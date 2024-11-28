module Evergreen.V21.Main.Layouts.Model exposing (..)

import Evergreen.V21.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V21.Layouts.Scaffold.Model
        }
