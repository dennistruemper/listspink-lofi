module Evergreen.V1.Pages.Lists.ListId_ exposing (..)

import Time


type alias Model =
    { listId : String
    , listName : Maybe String
    }


type Msg
    = ItemCheckedToggled String Bool
    | GotTimeForItemCheckedToggled String Bool Time.Posix
    | AddItemClicked
