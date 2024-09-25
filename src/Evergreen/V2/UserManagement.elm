module Evergreen.V2.UserManagement exposing (..)

import Dict
import Time


type alias UserOnDeviceData =
    { userId : String
    , deviceId : String
    , deviceName : String
    , userName : String
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
    }


type alias Model =
    { userSessions : Dict.Dict String SessionData
    , users : Dict.Dict String UserData
    }
