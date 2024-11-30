module Components.Select exposing (select, view)

import Html exposing (Html, text)
import Html.Attributes
import Html.Events


type alias Select msg a =
    { text : String
    , action : String -> msg
    , options : List a
    , toString : a -> String
    , selected : a
    }


select : String -> (String -> msg) -> List a -> (a -> String) -> a -> Select msg a
select text action options toString selected =
    { text = text
    , action = action
    , options = options
    , toString = toString
    , selected = selected
    }


view : Select msg a -> Html msg
view data =
    Html.div [ Html.Attributes.class "relative mt-3" ]
        [ Html.label
            [ Html.Attributes.for ("select-" ++ data.text)
            , Html.Attributes.class "absolute -top-2 left-2 inline-block bg-white px-1 text-xs font-medium text-gray-900"
            ]
            [ Html.text data.text ]
        , Html.select
            [ Html.Attributes.id ("select-" ++ data.text)
            , Html.Attributes.name data.text
            , Html.Attributes.class "block w-full rounded-full border-0 py-1.5 text-gray-900 shadow-xs ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-fuchsia-600 sm:text-sm sm:leading-6"
            , Html.Events.onInput data.action
            ]
            (List.map
                (\option ->
                    Html.option
                        [ Html.Attributes.value (data.toString option)
                        , if option == data.selected then
                            Html.Attributes.selected True

                          else
                            Html.Attributes.selected False
                        ]
                        [ Html.text (data.toString option) ]
                )
                data.options
            )
        ]
