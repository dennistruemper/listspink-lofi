module Evergreen.V22.Pages.Lists.Id_.CreateItem exposing (..)

import Evergreen.V22.ItemPriority
import Time


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , itemPriority : Evergreen.V22.ItemPriority.ItemPriority
    , error : Maybe String
    }


type BatchMode
    = SingleItem
    | MultipleItems


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | CreateMoreButtonClicked
    | GotTimeForCreateItem BatchMode Time.Posix
    | ItemPriorityChanged String
    | NoOp
    | BackClicked
