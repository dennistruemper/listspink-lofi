module Evergreen.V20.Pages.Admin.Users exposing (..)

import Evergreen.V20.Bridge
import Set


type alias Model =
    { loadedUsers : Maybe (List Evergreen.V20.Bridge.UserData)
    , expandedUsers : Set.Set String
    , searchQuery : String
    , userToDelete : Maybe String
    }


type Msg
    = NoOp
    | ToggleUserDetails String
    | RequestAdminData
    | GotUsers (List Evergreen.V20.Bridge.UserData)
    | UpdateSearchQuery String
    | DeleteUserClicked String
    | UserDeleted String
    | ConfirmDelete String
    | CancelDelete
    | ConfirmDeleteUser String
