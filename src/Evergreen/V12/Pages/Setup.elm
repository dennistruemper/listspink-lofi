module Evergreen.V12.Pages.Setup exposing (..)

import Evergreen.V12.Bridge
import Time


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Evergreen.V12.Bridge.User
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp
