module Evergreen.V2.Sync exposing (..)

import Array
import Dict
import Evergreen.V2.Event
import Evergreen.V2.SortedEventList
import Set
import Time


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V2.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : Evergreen.V2.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }
