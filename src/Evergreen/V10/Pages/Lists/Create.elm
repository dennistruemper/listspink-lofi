module Evergreen.V10.Pages.Lists.Create exposing (..)

import Time


type alias Model =
    { listName : String
    }


type Msg
    = ListNameChanged String
    | CreateListButtonClicked
    | GotTimeForCreateList Time.Posix
