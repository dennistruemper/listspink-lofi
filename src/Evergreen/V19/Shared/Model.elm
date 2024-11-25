module Evergreen.V19.Shared.Model exposing (..)

import Evergreen.V19.Bridge
import Evergreen.V19.Components.Toast
import Evergreen.V19.Event
import Evergreen.V19.Subscriptions
import Evergreen.V19.Sync
import Evergreen.V19.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V19.UserManagement.Model
        , backendSyncModel : Evergreen.V19.Sync.BackendSyncModel
        , subscriptions : Evergreen.V19.Subscriptions.Model
        }
    , user : Maybe Evergreen.V19.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V19.Sync.FrontendSyncModel
    , state : Evergreen.V19.Event.State
    , menuOpen : Bool
    , version : Maybe String
    , toasts : Evergreen.V19.Components.Toast.Model
    }
