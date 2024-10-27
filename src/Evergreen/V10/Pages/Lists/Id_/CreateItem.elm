module Evergreen.V10.Pages.Lists.Id_.CreateItem exposing (..)

import Evergreen.V10.ItemPriority
import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , itemPriority : Evergreen.V10.ItemPriority.ItemPriority
    , error : Maybe String
    }


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix
    | ItemPriorityChanged String
