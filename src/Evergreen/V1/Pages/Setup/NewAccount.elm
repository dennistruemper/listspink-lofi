module Evergreen.V1.Pages.Setup.NewAccount exposing (..)


type alias Model =
    { userName : String
    , deviceName : String
    , validation : Maybe String
    }


type Msg
    = Create
    | UsernameChanged String
    | DeviceNameChanged String
