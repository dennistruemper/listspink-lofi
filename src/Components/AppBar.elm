module Components.AppBar exposing (appBar, view, withActions, withContent)

import Components.Row as Row
import Html exposing (Html)
import Html.Attributes


type alias Model msg =
    { content : List (Html msg)
    , actions : List (Html msg)
    }


appBar : Model msg
appBar =
    { content = []
    , actions = []
    }


withContent : List (Html msg) -> Model msg -> Model msg
withContent content model =
    { model | content = content }


withActions : List (Html msg) -> Model msg -> Model msg
withActions actions model =
    { model | actions = actions }


view : Model msg -> Html msg
view data =
    Html.div [ Html.Attributes.class "h-full flex flex-col" ]
        [ Html.div [ Html.Attributes.class "h-full overflow-y-scroll px-2 lg:px-4" ]
            data.content
        , Html.div [ Html.Attributes.class "w-full h-12 bg-white border-t p-2 border-gray-200 dark:bg-gray-700 dark:border-gray-600" ]
            [ Row.row
                data.actions
                |> Row.withAlignment Row.NoneAlingment
                |> Row.withSpacing Row.Between
                |> Row.view
            ]
        ]
