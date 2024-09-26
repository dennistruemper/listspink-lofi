module Evergreen.V4.Shared.Model exposing (..)

import Evergreen.V4.Bridge
import Evergreen.V4.Event
import Evergreen.V4.Subscriptions
import Evergreen.V4.Sync
import Evergreen.V4.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V4.UserManagement.Model
        , backendSyncModel : Evergreen.V4.Sync.BackendSyncModel
        , subscriptions : Evergreen.V4.Subscriptions.Model
        }
    , user : Maybe Evergreen.V4.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V4.Sync.FrontendSyncModel
    , state : Evergreen.V4.Event.State
    , menuOpen : Bool
    }
