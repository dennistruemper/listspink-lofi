module Components.Row exposing (Alignment(..), Padding(..), Spacing(..), row, view, withAlignment, withPadding, withSpacing)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type Alignment
    = Start
    | Center
    | End
    | NoneAlingment


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


type Spacing
    = Between
    | Around
    | Evenly
    | NoneSpacing


spacingClass : Spacing -> String
spacingClass spacing =
    case spacing of
        Between ->
            "justify-between"

        Around ->
            "justify-around"

        Evenly ->
            "justify-evenly"

        NoneSpacing ->
            ""


type alias Column msg =
    { content : List (Html msg)
    , alignment : Alignment
    , padding : Padding
    , spacing : Spacing
    }


row : List (Html msg) -> Column msg
row content =
    { content = content
    , alignment = Start
    , padding = NoPadding
    , spacing = Evenly
    }


withAlignment : Alignment -> Column msg -> Column msg
withAlignment alignment data =
    { data | alignment = alignment }


withSpacing : Spacing -> Column msg -> Column msg
withSpacing spacing data =
    { data | spacing = spacing }


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

                NoneAlingment ->
                    ""
    in
    Html.div
        [ Attr.class
            ("flex flex-row h-full w-full gap-2 justify-end "
                ++ paddingClass data.padding
                ++ " "
                ++ alignment
                ++ " "
                ++ spacingClass data.spacing
            )
        ]
        data.content
