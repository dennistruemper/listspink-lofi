module Evergreen.V21.Shared.Model exposing (..)

import Evergreen.V21.Bridge
import Evergreen.V21.Components.Toast
import Evergreen.V21.Event
import Evergreen.V21.NetworkStatus
import Evergreen.V21.Sync


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { user : Maybe Evergreen.V21.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V21.Sync.FrontendSyncModel
    , state : Evergreen.V21.Event.State
    , menuOpen : Bool
    , version : Maybe String
    , toasts : Evergreen.V21.Components.Toast.Model
    , networkStatus : Evergreen.V21.NetworkStatus.NetworkStatus
    }
