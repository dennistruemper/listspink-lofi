module Evergreen.V7.Shared.Model exposing (..)

import Evergreen.V7.Bridge
import Evergreen.V7.Event
import Evergreen.V7.Subscriptions
import Evergreen.V7.Sync
import Evergreen.V7.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V7.UserManagement.Model
        , backendSyncModel : Evergreen.V7.Sync.BackendSyncModel
        , subscriptions : Evergreen.V7.Subscriptions.Model
        }
    , user : Maybe Evergreen.V7.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V7.Sync.FrontendSyncModel
    , state : Evergreen.V7.Event.State
    , menuOpen : Bool
    }
