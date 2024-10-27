module Evergreen.V10.Pages.Setup exposing (..)

import Evergreen.V10.Bridge
import Time


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Evergreen.V10.Bridge.User
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp
