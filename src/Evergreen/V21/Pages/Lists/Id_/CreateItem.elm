module Evergreen.V21.Pages.Lists.Id_.CreateItem exposing (..)

import Evergreen.V21.ItemPriority
import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , itemPriority : Evergreen.V21.ItemPriority.ItemPriority
    , error : Maybe String
    }


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix
    | ItemPriorityChanged String
