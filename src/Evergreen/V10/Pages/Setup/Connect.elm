module Evergreen.V10.Pages.Setup.Connect exposing (..)


type alias Model =
    { codeInput : String
    , deviceName : String
    , validation : Maybe String
    , redirect : Maybe String
    }


type Msg
    = CodeInputChanged String
    | DeviceNameChanged String
    | OkButtonClicked
