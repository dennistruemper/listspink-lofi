module Evergreen.V12.Layouts.Scaffold exposing (..)

import Evergreen.V12.Auth
import Evergreen.V12.Route.Path


type alias Model =
    { user : Evergreen.V12.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V12.Route.Path.Path
