module Evergreen.V7.Pages.Setup exposing (..)

import Evergreen.V7.Bridge
import Time


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Evergreen.V7.Bridge.User
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp
