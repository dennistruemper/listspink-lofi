module Evergreen.V20.Sync exposing (..)

import Array
import Dict
import Evergreen.V20.Event
import Evergreen.V20.SortedEventList
import Set
import Time


type alias FrontendSyncModel =
    { events : Evergreen.V20.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V20.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }
