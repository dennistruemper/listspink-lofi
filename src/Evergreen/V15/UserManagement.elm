module Evergreen.V15.UserManagement exposing (..)

import Dict
import Evergreen.V15.Role
import Time


type alias UserOnDeviceData =
    { userId : String
    , deviceId : String
    , deviceName : String
    , userName : String
    , roles : List Evergreen.V15.Role.Role
    }


type alias SessionData =
    { userId : String
    , deviceId : String
    , sessionId : String
    , createdAt : Time.Posix
    }


type alias SyncData =
    { startedAt : Time.Posix
    , code : String
    }


type alias UserData =
    { name : String
    , devices :
        List
            { deviceId : String
            , name : String
            }
    , userId : String
    , syncInProgress : Maybe SyncData
    , roles : List Evergreen.V15.Role.Role
    }


type alias Model =
    { userSessions : Dict.Dict String SessionData
    , users : Dict.Dict String UserData
    }
