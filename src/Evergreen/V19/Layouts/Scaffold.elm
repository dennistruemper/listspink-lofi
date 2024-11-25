module Evergreen.V19.Layouts.Scaffold exposing (..)

import Evergreen.V19.Auth
import Evergreen.V19.Route.Path


type alias Model =
    { user : Evergreen.V19.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V19.Route.Path.Path
    | ToastRemoveToast Int
