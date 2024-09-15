module Components.Center exposing (Padding(..), center, view, withPadding)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type alias Center msg =
    { content : List (Html msg)
    , padding : Padding
    }


type Padding
    = SmallPadding
    | MediumPadding
    | LargePadding
    | NoPadding


paddingClass : Padding -> String
paddingClass padding =
    case padding of
        SmallPadding ->
            "p-2"

        MediumPadding ->
            "p-4"

        LargePadding ->
            "p-8"

        NoPadding ->
            "p-0"


center : List (Html msg) -> Center msg
center content =
    { content = content
    , padding = NoPadding
    }


withPadding : Padding -> Center msg -> Center msg
withPadding padding data =
    { data | padding = padding }


view : Center msg -> Html msg
view data =
    Html.div
        [ Attr.class ("flex flex-col w-full h-full justify-center items-center " ++ paddingClass data.padding)
        ]
        data.content
