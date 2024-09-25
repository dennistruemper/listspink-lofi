module Evergreen.V2.Shared.Model exposing (..)

import Evergreen.V2.Bridge
import Evergreen.V2.Event
import Evergreen.V2.Subscriptions
import Evergreen.V2.Sync
import Evergreen.V2.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V2.UserManagement.Model
        , backendSyncModel : Evergreen.V2.Sync.BackendSyncModel
        , subscriptions : Evergreen.V2.Subscriptions.Model
        }
    , user : Maybe Evergreen.V2.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V2.Sync.FrontendSyncModel
    , state : Evergreen.V2.Event.State
    , menuOpen : Bool
    }
