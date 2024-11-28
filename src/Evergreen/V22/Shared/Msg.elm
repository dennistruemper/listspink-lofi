module Evergreen.V22.Shared.Msg exposing (..)

import Evergreen.V22.Bridge
import Evergreen.V22.Components.Toast
import Evergreen.V22.Event
import Evergreen.V22.Role
import Evergreen.V22.Status
import Time


type Msg
    = NewUserCreated Evergreen.V22.Bridge.User
    | NoOp
    | AddEvent Evergreen.V22.Event.EventDefinition
    | GotSyncCode Int
    | GotUserData
        { name : String
        , userId : String
        , deviceId : String
        , deviceName : String
        , roles : List Evergreen.V22.Role.Role
        }
    | GotMessageFromJs String
    | ConnectionEstablished
    | GotSyncResult
        { events : List Evergreen.V22.Event.EventDefinition
        , lastSyncServerTime : Time.Posix
        }
    | UserRolesUpdated
        { userId : String
        , roles : List Evergreen.V22.Role.Role
        }
    | SidebarToggled Bool
    | AddToast Evergreen.V22.Components.Toast.Toast
    | ToastMsg Evergreen.V22.Components.Toast.Msg
    | NotAuthenticated
    | StatusResponse Evergreen.V22.Status.Status String
