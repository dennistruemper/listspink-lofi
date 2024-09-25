module Evergreen.V2.Pages.Setup.NewAccount exposing (..)


type alias Model =
    { userName : String
    , deviceName : String
    , validation : Maybe String
    , initialState : Bool
    }


type Msg
    = Create
    | UsernameChanged String
    | DeviceNameChanged String
