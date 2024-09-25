module Evergreen.V2.Layouts.Scaffold exposing (..)

import Evergreen.V2.Auth
import Evergreen.V2.Route.Path


type alias Model =
    { user : Evergreen.V2.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V2.Route.Path.Path
