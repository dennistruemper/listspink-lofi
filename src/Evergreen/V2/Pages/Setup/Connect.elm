module Evergreen.V2.Pages.Setup.Connect exposing (..)


type alias Model =
    { codeInput : String
    , deviceName : String
    , validation : Maybe String
    }


type Msg
    = CodeInputChanged String
    | DeviceNameChanged String
    | OkButtonClicked