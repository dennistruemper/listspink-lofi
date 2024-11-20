module Evergreen.V13.Shared.Model exposing (..)

import Evergreen.V13.Bridge
import Evergreen.V13.Event
import Evergreen.V13.Subscriptions
import Evergreen.V13.Sync
import Evergreen.V13.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V13.UserManagement.Model
        , backendSyncModel : Evergreen.V13.Sync.BackendSyncModel
        , subscriptions : Evergreen.V13.Subscriptions.Model
        }
    , user : Maybe Evergreen.V13.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V13.Sync.FrontendSyncModel
    , state : Evergreen.V13.Event.State
    , menuOpen : Bool
    }
