module Evergreen.V22.Sync exposing (..)

import Array
import Dict
import Evergreen.V22.Event
import Evergreen.V22.SortedEventList
import Set
import Time


type alias FrontendSyncModel =
    { events : Evergreen.V22.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set.Set String
    }


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V22.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }
