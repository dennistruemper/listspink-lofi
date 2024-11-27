module Evergreen.V20.Main.Layouts.Model exposing (..)

import Evergreen.V20.Layouts.Scaffold


type Model
    = Scaffold
        { scaffold : Evergreen.V20.Layouts.Scaffold.Model
        }
