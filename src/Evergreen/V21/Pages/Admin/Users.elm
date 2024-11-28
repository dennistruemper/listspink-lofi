module Evergreen.V21.Pages.Admin.Users exposing (..)

import Evergreen.V21.Bridge
import Set


type alias Model =
    { loadedUsers : Maybe (List Evergreen.V21.Bridge.UserData)
    , expandedUsers : Set.Set String
    , searchQuery : String
    , userToDelete : Maybe String
    }


type Msg
    = NoOp
    | ToggleUserDetails String
    | RequestAdminData
    | GotUsers (List Evergreen.V21.Bridge.UserData)
    | UpdateSearchQuery String
    | DeleteUserClicked String
    | UserDeleted String
    | ConfirmDelete String
    | CancelDelete
    | ConfirmDeleteUser String
