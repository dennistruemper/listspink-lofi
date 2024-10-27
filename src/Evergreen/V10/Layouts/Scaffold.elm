module Evergreen.V10.Layouts.Scaffold exposing (..)

import Evergreen.V10.Auth
import Evergreen.V10.Route.Path


type alias Model =
    { user : Evergreen.V10.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V10.Route.Path.Path
