module Evergreen.V22.Pages.Lists.ListId_.Edit.ItemId_ exposing (..)

import Evergreen.V22.ItemPriority
import Time


type alias Model =
    { itemName : String
    , initialItemName : String
    , itemChecked : Bool
    , initialItemChecked : Bool
    , itemPriority : Evergreen.V22.ItemPriority.ItemPriority
    , initialItemPriority : Evergreen.V22.ItemPriority.ItemPriority
    , itemDescription : String
    , initialItemDescription : String
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
    | ItemDescriptionChanged String
