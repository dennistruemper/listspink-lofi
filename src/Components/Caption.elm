module Components.Caption exposing (caption1, caption2, caption3, caption4, view, withLine)

import Html exposing (Html, text)
import Html.Attributes as Attr
import Html.Events as Events


type Level
    = H1
    | H2
    | H3
    | H4


type alias Caption =
    { text : String
    , level : Level
    , line : Bool
    }


caption1 : String -> Caption
caption1 text =
    { text = text
    , level = H1
    , line = False
    }


caption2 : String -> Caption
caption2 text =
    { text = text
    , level = H2
    , line = False
    }


caption3 : String -> Caption
caption3 text =
    { text = text
    , level = H3
    , line = False
    }


caption4 : String -> Caption
caption4 text =
    { text = text
    , level = H4
    , line = False
    }


withLine : Bool -> Caption -> Caption
withLine value caption =
    { caption | line = value }


view : Caption -> Html msg
view data =
    let
        tag =
            case data.level of
                H1 ->
                    Html.h1

                H2 ->
                    Html.h2

                H3 ->
                    Html.h3

                H4 ->
                    Html.h4

        style =
            case data.level of
                H1 ->
                    "text-2xl lg:text-3xl font-bold"

                H2 ->
                    "text-2xl font-bold"

                H3 ->
                    "text-xl font-bold"

                H4 ->
                    "text-lg font-bold"

        line =
            if data.line then
                " border-b-2"

            else
                ""
    in
    tag [ Attr.class (style ++ " pt-2 " ++ line) ]
        [ text data.text ]
