module Evergreen.V22.Main.Layouts.Model exposing (..)

import Evergreen.V22.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V22.Layouts.Scaffold.Model
        }
