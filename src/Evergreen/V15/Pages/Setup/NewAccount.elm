module Evergreen.V15.Pages.Setup.NewAccount exposing (..)


type alias Model =
    { userName : String
    , deviceName : String
    , validation : Maybe String
    , initialState : Bool
    , redirect : Maybe String
    }


type Msg
    = Create
    | UsernameChanged String
    | DeviceNameChanged String
