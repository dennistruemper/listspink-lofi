module Evergreen.V4.Pages.Lists.Id_.CreateItem exposing (..)

import Evergreen.V4.ItemPriority
import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , itemPriority : Evergreen.V4.ItemPriority.ItemPriority
    , error : Maybe String
    }


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix
    | ItemPriorityChanged String
