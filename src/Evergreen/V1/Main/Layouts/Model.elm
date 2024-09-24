module Evergreen.V1.Main.Layouts.Model exposing (..)

import Evergreen.V1.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V1.Layouts.Scaffold.Model
        }
