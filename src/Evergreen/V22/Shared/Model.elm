module Evergreen.V22.Shared.Model exposing (..)

import Evergreen.V22.Bridge
import Evergreen.V22.Components.Toast
import Evergreen.V22.Event
import Evergreen.V22.NetworkStatus
import Evergreen.V22.Sync


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { user : Maybe Evergreen.V22.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V22.Sync.FrontendSyncModel
    , state : Evergreen.V22.Event.State
    , menuOpen : Bool
    , version : Maybe String
    , toasts : Evergreen.V22.Components.Toast.Model
    , networkStatus : Evergreen.V22.NetworkStatus.NetworkStatus
    }
