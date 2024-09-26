module Evergreen.V4.Sync exposing (..)

import Array
import Dict
import Evergreen.V4.Event
import Evergreen.V4.SortedEventList
import Set
import Time


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V4.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : Evergreen.V4.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }
