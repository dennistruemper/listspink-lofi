module Evergreen.V10.Sync exposing (..)

import Array
import Dict
import Evergreen.V10.Event
import Evergreen.V10.SortedEventList
import Set
import Time


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V10.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : Evergreen.V10.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }
