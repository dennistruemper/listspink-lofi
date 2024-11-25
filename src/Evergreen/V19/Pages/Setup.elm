module Evergreen.V19.Pages.Setup exposing (..)

import Evergreen.V19.Bridge
import Time


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Evergreen.V19.Bridge.User
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp
