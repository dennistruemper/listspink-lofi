module Evergreen.V22.Pages.Admin.Manual exposing (..)


type alias Model =
    { newUserId : String
    , newDeviceId : String
    , newUserName : String
    , newDeviceName : String
    }


type Msg
    = NewUseridChanged String
    | NewDeviceIdChanged String
    | NewUserNameChanged String
    | NewDeviceNameChanged String
    | CreateUserButtonClicked
    | ReconnectUser
