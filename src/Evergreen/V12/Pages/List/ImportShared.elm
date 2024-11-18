module Evergreen.V12.Pages.List.ImportShared exposing (..)


type alias Model =
    { value : String
    }


type Msg
    = InputChanged String
    | ImportClicked
