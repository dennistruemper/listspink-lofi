module Evergreen.V7.Layouts.Scaffold exposing (..)

import Evergreen.V7.Auth
import Evergreen.V7.Route.Path


type alias Model =
    { user : Evergreen.V7.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V7.Route.Path.Path
