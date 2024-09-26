module Evergreen.V3.Shared.Model exposing (..)

import Evergreen.V3.Bridge
import Evergreen.V3.Event
import Evergreen.V3.Subscriptions
import Evergreen.V3.Sync
import Evergreen.V3.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V3.UserManagement.Model
        , backendSyncModel : Evergreen.V3.Sync.BackendSyncModel
        , subscriptions : Evergreen.V3.Subscriptions.Model
        }
    , user : Maybe Evergreen.V3.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V3.Sync.FrontendSyncModel
    , state : Evergreen.V3.Event.State
    , menuOpen : Bool
    }
