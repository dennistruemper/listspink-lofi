module Evergreen.V1.Event exposing (..)

import Dict
import Time


type alias EventMetadata =
    { eventId : String
    , aggregateId : String
    , userId : String
    , timestamp : Time.Posix
    }


type EventData
    = ListCreated
        { listId : String
        , name : String
        }
    | ListUpdated
        { listId : String
        , name : String
        }


type EventDefinition
    = Event EventMetadata EventData


type alias PinkList =
    { name : String
    , listId : String
    }


type alias State =
    { lists : Dict.Dict String PinkList
    }
