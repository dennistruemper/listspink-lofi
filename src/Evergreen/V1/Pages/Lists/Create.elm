module Evergreen.V1.Pages.Lists.Create exposing (..)

import Time


type alias Model =
    { listName : String
    }


type Msg
    = ListNameChanged String
    | CreateListButtonClicked
    | GotTimeForCreateList Time.Posix
