module Evergreen.V19.Pages.Lists.Id_.CreateItem exposing (..)

import Evergreen.V19.ItemPriority
import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , itemPriority : Evergreen.V19.ItemPriority.ItemPriority
    , error : Maybe String
    }


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix
    | ItemPriorityChanged String
