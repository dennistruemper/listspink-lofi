module Evergreen.V1.Layouts.Scaffold exposing (..)

import Evergreen.V1.Auth
import Evergreen.V1.Route.Path


type alias Model =
    { user : Evergreen.V1.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V1.Route.Path.Path
