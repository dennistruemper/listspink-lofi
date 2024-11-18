module Evergreen.V12.Shared.Model exposing (..)

import Evergreen.V12.Bridge
import Evergreen.V12.Event
import Evergreen.V12.Subscriptions
import Evergreen.V12.Sync
import Evergreen.V12.UserManagement


type alias NextIds =
    { userId : String
    , deviceId : String
    , eventId : String
    , listId : String
    , itemId : String
    }


type alias Model =
    { adminData :
        { userManagement : Evergreen.V12.UserManagement.Model
        , backendSyncModel : Evergreen.V12.Sync.BackendSyncModel
        , subscriptions : Evergreen.V12.Subscriptions.Model
        }
    , user : Maybe Evergreen.V12.Bridge.User
    , syncCode : Maybe Int
    , nextIds : Maybe NextIds
    , syncModel : Evergreen.V12.Sync.FrontendSyncModel
    , state : Evergreen.V12.Event.State
    , menuOpen : Bool
    }
