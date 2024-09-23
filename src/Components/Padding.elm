module Components.Padding exposing (left, view)

import Html exposing (Html, text)
import Html.Attributes
import Html.Events as Events


type alias Padding msg =
    { children : List (Html msg)
    }


left : List (Html msg) -> Padding msg
left children =
    { children = children
    }


view : Padding msg -> Html msg
view data =
    Html.div [ Html.Attributes.class "pl-2 lg:pl-4" ] data.children
