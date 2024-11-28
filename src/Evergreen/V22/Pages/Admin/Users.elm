module Evergreen.V22.Pages.Admin.Users exposing (..)

import Evergreen.V22.Bridge
import Set


type alias Model =
    { loadedUsers : Maybe (List Evergreen.V22.Bridge.UserData)
    , expandedUsers : Set.Set String
    , searchQuery : String
    , userToDelete : Maybe String
    }


type Msg
    = NoOp
    | ToggleUserDetails String
    | RequestAdminData
    | GotUsers (List Evergreen.V22.Bridge.UserData)
    | UpdateSearchQuery String
    | DeleteUserClicked String
    | UserDeleted String
    | ConfirmDelete String
    | CancelDelete
    | ConfirmDeleteUser String
