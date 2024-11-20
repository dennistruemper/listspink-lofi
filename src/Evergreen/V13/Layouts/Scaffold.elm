module Evergreen.V13.Layouts.Scaffold exposing (..)

import Evergreen.V13.Auth
import Evergreen.V13.Route.Path


type alias Model =
    { user : Evergreen.V13.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V13.Route.Path.Path
