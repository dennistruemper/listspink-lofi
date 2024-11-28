module Evergreen.V21.Pages.Setup exposing (..)

import Evergreen.V21.Bridge
import Time


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Evergreen.V21.Bridge.User
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp
