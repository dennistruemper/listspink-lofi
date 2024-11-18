module Evergreen.V12.Event exposing (..)

import Dict
import Evergreen.V12.ItemPriority
import Time


type alias EventMetadata =
    { eventId : String
    , aggregateId : String
    , userId : String
    , timestamp : Time.Posix
    }


type alias ListCreatedData =
    { listId : String
    , name : String
    }


type alias ListUpdatedData =
    { name : String
    }


type alias ListSharedWithUserData =
    { userId : String
    , listId : String
    }


type alias ItemCreatedData =
    { itemId : String
    , itemName : String
    , itemDescription : Maybe String
    , itemPriority : Maybe Evergreen.V12.ItemPriority.ItemPriority
    }


type alias ItemStateChangedData =
    { itemId : String
    , newState : Bool
    }


type alias ItemUpdatedData =
    { itemId : String
    , listId : String
    , name : Maybe String
    , completed : Maybe (Maybe Time.Posix)
    , itemPriority : Maybe Evergreen.V12.ItemPriority.ItemPriority
    , description : Maybe String
    }


type EventData
    = ListCreated ListCreatedData
    | ListUpdated ListUpdatedData
    | ListSharedWithUser ListSharedWithUserData
    | ItemCreated ItemCreatedData
    | ItemStateChanged ItemStateChangedData
    | ItemUpdated ItemUpdatedData


type EventDefinition
    = Event EventMetadata EventData


type alias PinkItem =
    { name : String
    , itemId : String
    , description : Maybe String
    , createdAt : Time.Posix
    , completedAt : Maybe Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    , priority : Evergreen.V12.ItemPriority.ItemPriority
    }


type alias PinkList =
    { name : String
    , listId : String
    , items : Dict.Dict String PinkItem
    , createdAt : Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    , users : List String
    }


type alias State =
    { lists : Dict.Dict String PinkList
    }
