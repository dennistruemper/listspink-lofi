module Components.KeyListener exposing (onEnter, onEscape, onKey, onKeyUp, onKeys)

import Html
import Html.Events
import Json.Decode as Decode


onKeyUp : (String -> Maybe msg) -> Html.Attribute msg
onKeyUp toMsg =
    Html.Events.on "keyup"
        (Decode.field "key" Decode.string
            |> Decode.andThen
                (\key ->
                    case toMsg key of
                        Just msg ->
                            Decode.succeed msg

                        Nothing ->
                            Decode.fail "Key not handled"
                )
        )


onEnter : msg -> Html.Attribute msg
onEnter msg =
    onKeyUp
        (\key ->
            if key == "Enter" then
                Just msg

            else
                Nothing
        )


onEscape : msg -> Html.Attribute msg
onEscape msg =
    onKeyUp
        (\key ->
            if key == "Escape" then
                Just msg

            else
                Nothing
        )


onKey : String -> msg -> Html.Attribute msg
onKey targetKey msg =
    onKeyUp
        (\key ->
            if key == targetKey then
                Just msg

            else
                Nothing
        )


onKeys : List String -> msg -> Html.Attribute msg
onKeys targetKeys msg =
    onKeyUp
        (\key ->
            if List.member key targetKeys then
                Just msg

            else
                Nothing
        )
