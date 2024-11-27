module Evergreen.V20.Shared.Msg exposing (..)

import Evergreen.V20.Bridge
import Evergreen.V20.Components.Toast
import Evergreen.V20.Event
import Evergreen.V20.Role
import Evergreen.V20.Status
import Time


type Msg
    = NewUserCreated Evergreen.V20.Bridge.User
    | NoOp
    | AddEvent Evergreen.V20.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V20.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V20.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V20.Role.Role
        }
    | SidebarToggled Bool
    | AddToast Evergreen.V20.Components.Toast.Toast
    | ToastMsg Evergreen.V20.Components.Toast.Msg
    | NotAuthenticated
    | StatusResponse Evergreen.V20.Status.Status String
