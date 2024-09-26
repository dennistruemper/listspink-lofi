module Evergreen.V3.Pages.Setup exposing (..)


type alias Model =
    { redirect : Maybe String
    }


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotMessageFromJs String
