module Evergreen.V4.Layouts.Scaffold exposing (..)

import Evergreen.V4.Auth
import Evergreen.V4.Route.Path


type alias Model =
    { user : Evergreen.V4.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V4.Route.Path.Path
