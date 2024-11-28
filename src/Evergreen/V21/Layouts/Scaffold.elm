module Evergreen.V21.Layouts.Scaffold exposing (..)

import Evergreen.V21.Auth
import Evergreen.V21.Route.Path


type alias Model =
    { user : Evergreen.V21.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V21.Route.Path.Path
    | ToastRemoveToast Int
