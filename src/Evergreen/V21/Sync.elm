module Evergreen.V21.Sync exposing (..)

import Array
import Dict
import Evergreen.V21.Event
import Evergreen.V21.SortedEventList
import Set
import Time


type alias FrontendSyncModel =
    { events : Evergreen.V21.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V21.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }
