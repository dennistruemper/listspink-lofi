module Evergreen.V3.Layouts.Scaffold exposing (..)

import Evergreen.V3.Auth
import Evergreen.V3.Route.Path


type alias Model =
    { user : Evergreen.V3.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V3.Route.Path.Path
