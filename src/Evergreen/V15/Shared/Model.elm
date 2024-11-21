module Evergreen.V15.Shared.Model exposing (..)

import Evergreen.V15.Bridge
import Evergreen.V15.Event
import Evergreen.V15.Subscriptions
import Evergreen.V15.Sync
import Evergreen.V15.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V15.UserManagement.Model
        , backendSyncModel : Evergreen.V15.Sync.BackendSyncModel
        , subscriptions : Evergreen.V15.Subscriptions.Model
        }
    , user : Maybe Evergreen.V15.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V15.Sync.FrontendSyncModel
    , state : Evergreen.V15.Event.State
    , menuOpen : Bool
    , version : Maybe String
    }
