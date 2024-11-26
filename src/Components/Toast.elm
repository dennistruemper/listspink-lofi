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
    , withOnRemove
    , withPosition
    )

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Process
import Svg exposing (svg)
import Svg.Attributes as SvgAttr
import Task


type alias ToastId =
    Int


type Position
    = TopRight
    | TopLeft
    | BottomRight
    | BottomLeft


serializePosition : Position -> String
serializePosition position =
    case position of
        TopRight ->
            "top-right"

        TopLeft ->
            "top-left"

        BottomRight ->
            "bottom-right"

        BottomLeft ->
            "bottom-left"


deserializePosition : String -> Position
deserializePosition position =
    case position of
        "top-right" ->
            TopRight

        "top-left" ->
            TopLeft

        "bottom-right" ->
            BottomRight

        "bottom-left" ->
            BottomLeft

        _ ->
            TopRight


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
    , withRemove : Bool
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
    , withRemove = True
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


withOnRemove : Bool -> Toast -> Toast
withOnRemove withRemove toast =
    { toast | withRemove = withRemove }


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


viewSingle : (Msg -> msg) -> Toast -> Html msg
viewSingle convertMsg toast =
    Html.div
        [ Attr.class "mb-2 px-4 py-2 text-white rounded shadow-lg flex items-center justify-between"
        , Attr.class (typeToClass toast.toastType)
        ]
        ([ Html.text toast.message ]
            ++ (if toast.withRemove then
                    [ Html.button
                        [ Attr.class "ml-4 p-1 hover:bg-black/20 rounded transition-colors"
                        , Events.onClick (convertMsg (RemoveToast toast.id))
                        ]
                        [ svg
                            [ SvgAttr.width "16"
                            , SvgAttr.height "16"
                            , SvgAttr.viewBox "0 0 24 24"
                            , SvgAttr.fill "none"
                            , SvgAttr.stroke "currentColor"
                            , SvgAttr.strokeWidth "2"
                            , SvgAttr.strokeLinecap "round"
                            , SvgAttr.strokeLinejoin "round"
                            ]
                            [ Svg.path [ SvgAttr.d "M18 6L6 18" ] []
                            , Svg.path [ SvgAttr.d "M6 6l12 12" ] []
                            ]
                        ]
                    ]

                else
                    []
               )
        )


view : Model -> (Msg -> msg) -> Html msg
view model convertMsg =
    let
        toastsByPosition =
            model.toasts
                |> Dict.values
                |> List.foldr
                    (\toast acc ->
                        Dict.update (serializePosition toast.position)
                            (\maybeToasts ->
                                Just (toast :: Maybe.withDefault [] maybeToasts)
                            )
                            acc
                    )
                    Dict.empty

        viewContainer : Position -> List Toast -> Html msg
        viewContainer position toasts =
            let
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
                (List.map (viewSingle convertMsg) toasts)
    in
    Html.div []
        (toastsByPosition
            |> Dict.toList
            |> List.map (\( position, toasts ) -> viewContainer (deserializePosition position) toasts)
        )
