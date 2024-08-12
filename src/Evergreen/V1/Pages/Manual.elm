module Evergreen.V1.Pages.Manual exposing (..)


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
    | AdminDataRequested
    | ReconnectUser
