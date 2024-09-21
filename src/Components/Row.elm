module Components.Row exposing (Alignment(..), Padding(..), row, view, withAlignment, withPadding)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type Alignment
    = Start
    | Center
    | End


type Padding
    = SmallPadding
    | MediumPadding
    | LargePadding
    | NoPadding


paddingClass : Padding -> String
paddingClass padding =
    case padding of
        SmallPadding ->
            "p-1 lg:p-2"

        MediumPadding ->
            "p-2 lg:p-4"

        LargePadding ->
            "p-4 lg:p-8 "

        NoPadding ->
            "p-0"


type alias Column msg =
    { content : List (Html msg), alignment : Alignment, padding : Padding }


row : List (Html msg) -> Column msg
row content =
    { content = content, alignment = Start, padding = NoPadding }


withAlignment : Alignment -> Column msg -> Column msg
withAlignment alignment data =
    { data | alignment = alignment }


withPadding : Padding -> Column msg -> Column msg
withPadding padding data =
    { data | padding = padding }


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
        [ Attr.class ("flex flex-row h-full w-full gap-2 justify-end " ++ paddingClass data.padding ++ " " ++ alignment)
        ]
        data.content
