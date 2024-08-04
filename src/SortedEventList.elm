module SortedEventList exposing (Model, addEvent, findEvent, getEvents, init)

import Array exposing (Array)
import Event exposing (EventDefinition)
import Time


type alias Model =
    Array EventDefinition


init : Model
init =
    Array.empty


compare : EventDefinition -> EventDefinition -> Order
compare event1 event2 =
    let
        eventTimeValue1 =
            Event.getTime event1 |> Time.posixToMillis

        eventTimeValue2 =
            Event.getTime event2 |> Time.posixToMillis
    in
    if eventTimeValue1 < eventTimeValue2 then
        LT

    else if eventTimeValue1 > eventTimeValue2 then
        GT

    else
        EQ


addEvent : EventDefinition -> Model -> Model
addEvent event model =
    let
        maybeLastElement =
            Array.get (Array.length model - 1) model

        containsEvent =
            Array.filter (\e -> Event.getEventId e == Event.getEventId event) model |> (\arr -> Array.length arr > 0)
    in
    if containsEvent then
        model

    else
        case maybeLastElement of
            Just lastElement ->
                if compare event lastElement == LT then
                    sortIntoArray event model

                else
                    Array.push event model

            Nothing ->
                Array.push event model


sortIntoArray : EventDefinition -> Model -> Model
sortIntoArray event model =
    sortIntoArrayHelper event model 0 (Array.length model)


sortIntoArrayHelper : EventDefinition -> Model -> Int -> Int -> Model
sortIntoArrayHelper event model low high =
    if low == 0 && high == 0 then
        if compare event (Array.get 0 model |> Maybe.withDefault event) == LT then
            Array.append (Array.fromList [ event ]) model

        else
            Array.push event model

    else if low < high then
        let
            mid =
                (low + high) // 2

            midElement =
                Array.get mid model |> Maybe.withDefault event

            comparison =
                compare event midElement
        in
        if comparison == LT then
            sortIntoArrayHelper event model low mid

        else if comparison == GT then
            sortIntoArrayHelper event model (mid + 1) high

        else
            Array.fromList
                (Array.toList (Array.slice 0 mid model)
                    ++ [ event ]
                    ++ Array.toList (Array.slice mid (Array.length model) model)
                )

    else
        Array.push event model



-- search from the end, since the most recent events are at the end and might be more likely to be used


findEvent : String -> Model -> Maybe EventDefinition
findEvent eventId model =
    findEventHelper eventId (Array.length model) model


findEventHelper : String -> Int -> Model -> Maybe EventDefinition
findEventHelper eventId index model =
    if index < 0 then
        Nothing

    else
        let
            maybeEvent =
                Array.get index model
        in
        case maybeEvent of
            Just event ->
                if Event.getEventId event == eventId then
                    Just event

                else
                    findEventHelper eventId (index - 1) model

            Nothing ->
                findEventHelper eventId (index - 1) model


getEvents : Model -> List EventDefinition
getEvents model =
    Array.toList model
