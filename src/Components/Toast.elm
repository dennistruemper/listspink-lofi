module Components.Toast exposing
    ( Model
    , Msg(..)
    , Position(..)
    , Toast
    , addToast
    , error
    , info
    , init
    , success
    , update
    , view
    , warning
    , withDuration
    , withPosition
    )

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attr
import Process
import Task


type alias ToastId =
    Int


type Position
    = TopRight
    | TopLeft
    | BottomRight
    | BottomLeft


type ToastType
    = Success
    | Error
    | Info
    | Warning


type alias Toast =
    { id : ToastId
    , message : String
    , toastType : ToastType
    , position : Position
    , duration : Float -- in milliseconds
    }


type alias Model =
    { toasts : Dict ToastId Toast
    , nextId : ToastId
    }


type Msg
    = RemoveToast ToastId


init : Model
init =
    { toasts = Dict.empty
    , nextId = 0
    }


create : ToastType -> String -> Toast
create toastType message =
    { id = 0 -- This will be set in addToast
    , message = message
    , toastType = toastType
    , position = TopRight
    , duration = 3000
    }


success : String -> Toast
success message =
    create Success message


error : String -> Toast
error message =
    create Error message


info : String -> Toast
info message =
    create Info message


warning : String -> Toast
warning message =
    create Warning message


withPosition : Position -> Toast -> Toast
withPosition position toast =
    { toast | position = position }


withDuration : Float -> Toast -> Toast
withDuration duration toast =
    { toast | duration = duration }


update : Msg -> Model -> Model
update msg model =
    case msg of
        RemoveToast id ->
            { model | toasts = Dict.remove id model.toasts }


addToast : Toast -> Model -> ( Model, Int )
addToast toast model =
    ( { model | toasts = Dict.insert model.nextId toast model.toasts, nextId = model.nextId + 1 }, model.nextId )


typeToClass : ToastType -> String
typeToClass toastType =
    case toastType of
        Success ->
            "bg-green-500"

        Error ->
            "bg-red-500"

        Info ->
            "bg-blue-500"

        Warning ->
            "bg-yellow-500"


viewSingle : Toast -> Html msg
viewSingle toast =
    Html.div
        [ Attr.class "mb-2 px-4 py-2 text-white rounded shadow-lg"
        , Attr.class (typeToClass toast.toastType)
        ]
        [ Html.text toast.message ]


view : Model -> Html msg
view model =
    let
        -- Get position from first toast, default to TopRight
        position =
            model.toasts
                |> Dict.values
                |> List.head
                |> Maybe.map .position
                |> Maybe.withDefault TopRight

        containerPosition =
            case position of
                TopRight ->
                    "top-4 right-4"

                TopLeft ->
                    "top-4 left-4"

                BottomRight ->
                    "bottom-4 right-4"

                BottomLeft ->
                    "bottom-4 left-4"
    in
    Html.div
        [ Attr.class "fixed z-50 flex flex-col min-w-[200px] max-w-[400px]"
        , Attr.class containerPosition
        ]
        (model.toasts
            |> Dict.values
            |> List.map viewSingle
        )
