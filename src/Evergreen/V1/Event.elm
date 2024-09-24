module Evergreen.V1.Event exposing (..)

import Dict
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


type alias ItemCreatedData =
    { itemId : String
    , itemName : String
    , itemDescription : Maybe String
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
    }


type EventData
    = ListCreated ListCreatedData
    | ListUpdated ListUpdatedData
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
    }


type alias PinkList =
    { name : String
    , listId : String
    , items : Dict.Dict String PinkItem
    , createdAt : Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    }


type alias State =
    { lists : Dict.Dict String PinkList
    }
