module Evergreen.V2.Pages.Lists.ListId_.Edit.ItemId_ exposing (..)

import Evergreen.V2.ItemPriority
import Time


type alias Model =
    { itemName : String
    , initialItemName : String
    , itemChecked : Bool
    , initialItemChecked : Bool
    , itemPriority : Evergreen.V2.ItemPriority.ItemPriority
    , initialItemPriority : Evergreen.V2.ItemPriority.ItemPriority
    , listId : String
    , itemId : String
    , createdAt : Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    }


type Msg
    = SaveClicked
    | NameChanged String
    | DoneClicked Bool
    | GotTimeForUpdatedItem Time.Posix
    | ItemPriorityChanged String
