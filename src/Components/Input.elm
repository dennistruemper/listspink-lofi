module Components.Input exposing (text, view, withId)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


type alias Input msg =
    { caption : String
    , value : String
    , placeholder : String
    , action : String -> msg
    , error : Maybe String
    , id : Maybe String
    }


text : String -> (String -> msg) -> Maybe String -> String -> Input msg
text caption action error value =
    { caption = caption
    , value = value
    , placeholder = caption
    , action = action
    , error = error
    , id = Nothing
    }


withId : String -> Input msg -> Input msg
withId id data =
    { data | id = Just id }


withPlaceholder : String -> Input msg -> Input msg
withPlaceholder placeholder data =
    { data | placeholder = placeholder }


view : Input msg -> Html msg
view data =
    let
        hideError =
            case data.error of
                Just _ ->
                    ""

                Nothing ->
                    "hidden "

        errorMessage =
            case data.error of
                Just message ->
                    message

                Nothing ->
                    ""
    in
    Html.div [ Attr.class "pt-2" ]
        [ Html.div
            [ Attr.class "relative"
            ]
            [ Html.label
                [ Attr.for data.caption
                , Attr.class "absolute -top-2 left-2 inline-block bg-white px-1 text-xs font-medium text-gray-900"
                ]
                [ Html.text data.caption ]
            , Html.input
                [ Attr.type_ "text"
                , Attr.name data.caption
                , Attr.id data.caption
                , Attr.value data.value
                , Events.onInput data.action
                , Attr.class "block w-full rounded-full border-0 py-1.5 text-gray-900 shadow-xs ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-fuchsia-600 sm:text-sm sm:leading-6"
                , Attr.placeholder data.placeholder
                , Attr.id (Maybe.withDefault (nameToId data.caption) data.id)
                ]
                []
            , Html.div
                [ Attr.class (hideError ++ "pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3")
                ]
                [ svg
                    [ SvgAttr.class "h-5 w-5 text-red-500"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            ]
        , Html.p
            [ Attr.class "mt-2 text-sm text-red-600"
            , Attr.id (data.caption ++ "-error")
            ]
            [ Html.text errorMessage ]
        ]


nameToId : String -> String
nameToId name =
    String.toLower name |> String.replace " " "-" |> (\s -> s ++ "-input")
