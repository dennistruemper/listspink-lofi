module Evergreen.V21.Shared.Msg exposing (..)

import Evergreen.V21.Bridge
import Evergreen.V21.Components.Toast
import Evergreen.V21.Event
import Evergreen.V21.Role
import Evergreen.V21.Status
import Time


type Msg
    = NewUserCreated Evergreen.V21.Bridge.User
    | NoOp
    | AddEvent Evergreen.V21.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V21.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V21.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V21.Role.Role
        }
    | SidebarToggled Bool
    | AddToast Evergreen.V21.Components.Toast.Toast
    | ToastMsg Evergreen.V21.Components.Toast.Msg
    | NotAuthenticated
    | StatusResponse Evergreen.V21.Status.Status String
