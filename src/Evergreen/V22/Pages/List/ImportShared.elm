module Evergreen.V22.Pages.List.ImportShared exposing (..)


type alias Model =
    { value : String
    }


type Msg
    = InputChanged String
    | ImportClicked