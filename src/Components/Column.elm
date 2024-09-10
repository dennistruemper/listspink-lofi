module Components.Column exposing (column, view)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type Alignment
    = Start
    | Center
    | End


type alias Column msg =
    { content : List (Html msg), alignment : Alignment }


column : List (Html msg) -> Column msg
column content =
    { content = content, alignment = Start }


withAlignment : Alignment -> Column msg -> Column msg
withAlignment alignment data =
    { data | alignment = alignment }


view : Column msg -> Html msg
view data =
    let
        alignment =
            case data.alignment of
                Start ->
                    "items-start"

                Center ->
                    "items-center"

                End ->
                    "items-end"
    in
    Html.div
        [ Attr.class ("flex flex-col h-full gap-2 p-2 " ++ alignment)
        ]
        data.content
