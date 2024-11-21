module Evergreen.V15.Layouts.Scaffold exposing (..)

import Evergreen.V15.Auth
import Evergreen.V15.Route.Path


type alias Model =
    { user : Evergreen.V15.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V15.Route.Path.Path
