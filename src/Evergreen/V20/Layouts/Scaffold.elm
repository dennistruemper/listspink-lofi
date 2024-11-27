module Evergreen.V20.Layouts.Scaffold exposing (..)

import Evergreen.V20.Auth
import Evergreen.V20.Route.Path


type alias Model =
    { user : Evergreen.V20.Auth.User
    }


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Evergreen.V20.Route.Path.Path
    | ToastRemoveToast Int
