module Components.Button exposing (button, view, withDisabled)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type alias Button msg =
    { text : String
    , action : msg
    , disabled : Bool
    }


button : String -> msg -> Button msg
button text action =
    { text = text
    , action = action
    , disabled = False
    }


withDisabled : Bool -> Button msg -> Button msg
withDisabled disabled data =
    { data | disabled = disabled }


view : Button msg -> Html msg
view data =
    let
        bgColor =
            if data.disabled then
                "bg-gray-400"

            else
                "bg-fuchsia-500 hover:bg-fuchsia-400"
    in
    Html.button
        [ Attr.type_ "button"
        , Events.onClick data.action
        , Attr.class <| "rounded-full " ++ bgColor ++ " px-3.5 py-2 text-sm font-semibold text-white shadow-xs focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-fuchsia-500"
        , Attr.disabled data.disabled
        ]
        [ text data.text ]
