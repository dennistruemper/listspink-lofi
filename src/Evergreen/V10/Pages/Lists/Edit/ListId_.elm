module Evergreen.V10.Pages.Lists.Edit.ListId_ exposing (..)

import Time


type alias Model =
    { listId : String
    , listName : Maybe String
    , fullHostNameAndPort : String
    }


type Msg
    = ListNameChanged String
    | UpdateListButtonClicked
    | GotTimeForUpdateList Time.Posix
    | CopyShareLinkClicked String
