module Evergreen.V4.Main.Layouts.Model exposing (..)

import Evergreen.V4.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V4.Layouts.Scaffold.Model
        }
