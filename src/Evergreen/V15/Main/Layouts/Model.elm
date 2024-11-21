module Evergreen.V15.Main.Layouts.Model exposing (..)

import Evergreen.V15.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V15.Layouts.Scaffold.Model
        }
