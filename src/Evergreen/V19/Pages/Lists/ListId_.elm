module Evergreen.V19.Pages.Lists.ListId_ exposing (..)

import Time


type alias Model =
    { listId : String
    , listName : Maybe String
    , currentTime : Time.Posix
    , showDoneAfter : Int
    }


type Msg
    = ItemCheckedToggled String Bool
    | GotTimeForItemCheckedToggled String Bool Time.Posix
    | AddItemClicked
    | GotCurrentTime Time.Posix
    | ToggleArchiveClicked
