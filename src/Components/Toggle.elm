module Components.Toggle exposing (toggle, view)

import Html exposing (Html)
import Html.Attributes
import Html.Events as Events
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


type alias Toggle msg =
    { caption : String
    , value : Bool
    , action : Bool -> msg
    }


toggle : String -> (Bool -> msg) -> Bool -> Toggle msg
toggle caption action value =
    { caption = caption
    , value = value
    , action = action
    }


stringFromBool : Bool -> String
stringFromBool value =
    if value then
        "True"

    else
        "False"


view : Toggle msg -> Html msg
view data =
    let
        toggleClass =
            if data.value then
                "bg-indigo-600"

            else
                "bg-gray-200"

        translateX =
            if data.value then
                "translate-x-5"

            else
                "translate-x-0"

        opacityX =
            if data.value then
                "opacity-100 duration-200 ease-in"

            else
                "opacity-0 duration-100 ease-out"

        opacityCheck =
            if data.value then
                "opacity-0 duration-100 ease-out"

            else
                "opacity-100 duration-200 ease-in"
    in
    {- Enabled: "bg-indigo-600", Not Enabled: "bg-gray-200" -}
    Html.div [ Html.Attributes.class "flex flex-row items-center" ]
        [ Html.button
            [ Html.Attributes.type_ "button"
            , Html.Attributes.class ("relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent " ++ toggleClass ++ " transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-600 focus:ring-offset-2")
            , Html.Attributes.attribute "role" "switch"
            , Html.Attributes.attribute "aria-checked" "false"
            , Events.onClick (data.action (not data.value))
            ]
            [ Html.span
                [ Html.Attributes.class "sr-only"
                ]
                [ Html.text "Use setting" ]
            , {- Enabled: "translate-x-5", Not Enabled: "translate-x-0" -}
              Html.span
                [ Html.Attributes.class ("pointer-events-none relative inline-block h-5 w-5 " ++ translateX ++ " transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out")
                ]
                [ {- Enabled: "opacity-0 duration-100 ease-out", Not Enabled: "opacity-100 duration-200 ease-in" -}
                  Html.span
                    [ Html.Attributes.class ("absolute inset-0 flex h-full w-full items-center justify-center transition-opacity " ++ opacityCheck)
                    , Html.Attributes.attribute "aria-hidden" "true"
                    ]
                    [ svg
                        [ SvgAttr.class "h-3 w-3 text-gray-400"
                        , SvgAttr.fill "none"
                        , SvgAttr.viewBox "0 0 12 12"
                        ]
                        [ path
                            [ SvgAttr.d "M4 8l2-2m0 0l2-2M6 6L4 4m2 2l2 2"
                            , SvgAttr.stroke "currentColor"
                            , SvgAttr.strokeWidth "2"
                            , SvgAttr.strokeLinecap "round"
                            , SvgAttr.strokeLinejoin "round"
                            ]
                            []
                        ]
                    ]
                , {- Enabled: "opacity-100 duration-200 ease-in", Not Enabled: "opacity-0 duration-100 ease-out" -}
                  Html.span
                    [ Html.Attributes.class ("absolute inset-0 flex h-full w-full items-center justify-center transition-opacity " ++ opacityX)
                    , Html.Attributes.attribute "aria-hidden" "true"
                    ]
                    [ svg
                        [ SvgAttr.class "h-3 w-3 text-indigo-600"
                        , SvgAttr.fill "currentColor"
                        , SvgAttr.viewBox "0 0 12 12"
                        ]
                        [ path
                            [ SvgAttr.d "M3.707 5.293a1 1 0 00-1.414 1.414l1.414-1.414zM5 8l-.707.707a1 1 0 001.414 0L5 8zm4.707-3.293a1 1 0 00-1.414-1.414l1.414 1.414zm-7.414 2l2 2 1.414-1.414-2-2-1.414 1.414zm3.414 2l4-4-1.414-1.414-4 4 1.414 1.414z"
                            ]
                            []
                        ]
                    ]
                ]
            ]
        , Html.span [ Html.Attributes.class "pl-2 lg:pl-4" ] [ Html.text data.caption ]
        ]
