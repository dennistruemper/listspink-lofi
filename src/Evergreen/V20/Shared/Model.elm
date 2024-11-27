module Evergreen.V20.Shared.Model exposing (..)

import Evergreen.V20.Bridge
import Evergreen.V20.Components.Toast
import Evergreen.V20.Event
import Evergreen.V20.Sync


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { user : Maybe Evergreen.V20.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V20.Sync.FrontendSyncModel
    , state : Evergreen.V20.Event.State
    , menuOpen : Bool
    , version : Maybe String
    , toasts : Evergreen.V20.Components.Toast.Model
    }
