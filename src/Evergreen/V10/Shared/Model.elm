module Evergreen.V10.Shared.Model exposing (..)

import Evergreen.V10.Bridge
import Evergreen.V10.Event
import Evergreen.V10.Subscriptions
import Evergreen.V10.Sync
import Evergreen.V10.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V10.UserManagement.Model
        , backendSyncModel : Evergreen.V10.Sync.BackendSyncModel
        , subscriptions : Evergreen.V10.Subscriptions.Model
        }
    , user : Maybe Evergreen.V10.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V10.Sync.FrontendSyncModel
    , state : Evergreen.V10.Event.State
    , menuOpen : Bool
    }
