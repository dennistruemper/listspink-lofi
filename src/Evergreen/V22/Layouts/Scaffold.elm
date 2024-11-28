module Evergreen.V22.Layouts.Scaffold exposing (..)

import Evergreen.V22.Auth
import Evergreen.V22.Route.Path


type alias Model =
    { user : Evergreen.V22.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V22.Route.Path.Path
    | ToastRemoveToast Int
