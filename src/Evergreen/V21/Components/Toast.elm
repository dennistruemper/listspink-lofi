module Evergreen.V21.Components.Toast exposing (..)

import Dict


type alias ToastId =
    Int


type ToastType
    = Success
    | Error
    | Info
    | Warning


type Position
    = TopRight
    | TopLeft
    | BottomRight
    | BottomLeft


type alias Toast =
    { id : ToastId
    , message : String
    , toastType : ToastType
    , position : Position
    , duration : Float
    , withRemove : Bool
    }


type alias Model =
    { toasts : Dict.Dict ToastId Toast
    , nextId : ToastId
    }


type Msg
    = RemoveToast ToastId
