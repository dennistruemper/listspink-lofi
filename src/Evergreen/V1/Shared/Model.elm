module Evergreen.V1.Shared.Model exposing (..)

import Evergreen.V1.Bridge
import Evergreen.V1.Event
import Evergreen.V1.Subscriptions
import Evergreen.V1.Sync
import Evergreen.V1.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V1.UserManagement.Model
        , backendSyncModel : Evergreen.V1.Sync.BackendSyncModel
        , subscriptions : Evergreen.V1.Subscriptions.Model
        }
    , user : Maybe Evergreen.V1.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V1.Sync.FrontendSyncModel
    , state : Evergreen.V1.Event.State
    , menuOpen : Bool
    }
