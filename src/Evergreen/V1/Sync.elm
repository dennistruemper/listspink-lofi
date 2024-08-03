module Evergreen.V1.Sync exposing (..)

import Array
import Dict
import Evergreen.V1.Event
import Evergreen.V1.SortedEventList
import Time


type alias BackendSyncModel =
    { aggregates :
        Dict.Dict
            String
            { events :
                Array.Array
                    { event : Evergreen.V1.Event.EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : Evergreen.V1.SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    }
