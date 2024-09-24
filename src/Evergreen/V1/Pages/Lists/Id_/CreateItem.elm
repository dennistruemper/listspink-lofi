module Evergreen.V1.Pages.Lists.Id_.CreateItem exposing (..)

import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , error : Maybe String
    }


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix
