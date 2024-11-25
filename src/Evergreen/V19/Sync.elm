module Evergreen.V19.Sync exposing (..)

import Array
import Dict
import Evergreen.V19.Event
import Evergreen.V19.SortedEventList
import Set
import Time


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V19.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : Evergreen.V19.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }
