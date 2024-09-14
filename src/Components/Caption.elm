module Components.Caption exposing (caption1, caption2, caption3, caption4, view)

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
    }


caption1 : String -> Caption
caption1 text =
    { text = text
    , level = H1
    }


caption2 : String -> Caption
caption2 text =
    { text = text
    , level = H2
    }


caption3 : String -> Caption
caption3 text =
    { text = text
    , level = H3
    }


caption4 : String -> Caption
caption4 text =
    { text = text
    , level = H4
    }


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
                    "text-3xl font-bold"

                H2 ->
                    "text-2xl font-bold"

                H3 ->
                    "text-xl font-bold"

                H4 ->
                    "text-lg font-bold"
    in
    tag [ Attr.class style ]
        [ text data.text ]
