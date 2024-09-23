module Components.Text exposing (keyValue, view)

import Html exposing (Html, text)
import Html.Attributes
import Html.Events as Events


type alias Text =
    { key : String
    , value : String
    }


keyValue : String -> String -> Text
keyValue key value =
    { key = key
    , value = value
    }


view : Text -> Html msg
view data =
    Html.p [ Html.Attributes.class " flex flex-row w-full justify-between" ] [ Html.p [ Html.Attributes.class "font-semibold" ] [ Html.text (data.key ++ ":") ], Html.text data.value ]
