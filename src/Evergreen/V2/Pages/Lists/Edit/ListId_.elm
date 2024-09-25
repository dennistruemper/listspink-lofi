module Evergreen.V2.Pages.Lists.Edit.ListId_ exposing (..)

import Time


type alias Model =
    { listId : String
    , listName : Maybe String
    }


type Msg
    = ListNameChanged String
    | UpdateListButtonClicked
    | GotTimeForUpdateList Time.Posix
