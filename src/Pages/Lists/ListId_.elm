module Pages.Lists.ListId_ exposing (Model, Msg, page)

import Dict
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Html
import Html.Attributes
import Html.Events
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Time
import View exposing (View)


page : Shared.Model -> Route { listId : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route.params.listId shared
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { listId : String
    , listName : Maybe String
    }


init : String -> Shared.Model -> () -> ( Model, Effect Msg )
init listId shared () =
    ( { listId = listId
      , listName =
            shared.state.lists
                |> Dict.values
                |> List.filter (\l -> l.listId == listId)
                |> List.head
                |> Maybe.map .name
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ListNameChanged String
    | UpdateListButtonClicked
    | GotTimeForUpdateList Time.Posix
    | ItemCheckedToggled String Bool
    | GotTimeForItemCheckedToggled String Bool Time.Posix


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ListNameChanged listName ->
            ( { model | listName = Just listName }, Effect.none )

        UpdateListButtonClicked ->
            ( model, Effect.getTime GotTimeForUpdateList )

        GotTimeForUpdateList timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    case EventMetadataHelper.createEventMetadata shared.nextIds (\ids -> model.listId) shared.user timestamp of
                        Ok eventMetadata ->
                            Ok eventMetadata

                        Err error ->
                            Err error
            in
            case eventResult of
                Ok eventMetadata ->
                    case model.listName of
                        Just listName ->
                            ( model, Effect.batch [ Effect.addEvent <| Event.createListUpdatedEvent eventMetadata { name = listName }, Effect.back ] )

                        -- todo handle error
                        Nothing ->
                            ( model, Effect.batch [] )

                Err error ->
                    --TODO
                    ( model, Effect.none )

        ItemCheckedToggled itemId checked ->
            ( model, Effect.getTime (GotTimeForItemCheckedToggled itemId checked) )

        GotTimeForItemCheckedToggled itemId checked timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    case
                        EventMetadataHelper.createEventMetadata
                            shared.nextIds
                            (\_ -> model.listId)
                            shared.user
                            timestamp
                    of
                        Ok eventMetadata ->
                            Ok eventMetadata

                        Err error ->
                            Err error
            in
            case eventResult of
                Ok eventMetadata ->
                    ( model, Effect.addEvent <| Event.createItemStateChangedEvent eventMetadata { itemId = itemId, newState = checked } )

                Err error ->
                    --TODO
                    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        maybeList =
            shared.state.lists
                |> Dict.values
                |> List.filter (\l -> l.listId == model.listId)
                |> List.head
    in
    { title = "Pages.Lists.ListId_"
    , body =
        [ case maybeList of
            Just list ->
                Html.div []
                    [ Html.input
                        [ Html.Attributes.value
                            (model.listName |> Maybe.withDefault list.name)
                        , Html.Events.onInput ListNameChanged
                        ]
                        []
                    , Html.button
                        [ Html.Events.onClick UpdateListButtonClicked
                        , Html.Attributes.disabled
                            ((model.listName |> Maybe.withDefault "" |> String.isEmpty)
                                && (model.listName |> Maybe.withDefault "")
                                /= list.name
                            )
                        ]
                        [ Html.text "Update List" ]
                    , Html.br [] []
                    , Html.a
                        [ Html.Attributes.href (Route.Path.toString (Route.Path.Lists_Id__CreateItem { id = model.listId })) ]
                        [ Html.text "Add Item" ]
                    , Html.br [] []
                    , Html.br [] []
                    , viewItems list
                    ]

            Nothing ->
                Html.text "List not found"
        ]
    }


viewItems : Event.PinkList -> Html.Html Msg
viewItems list =
    case Dict.values list.items of
        [] ->
            Html.text "No items jet"

        items ->
            Html.ul []
                (List.map
                    viewItem
                    (items |> sortByTimestamp)
                )


viewItem : Event.PinkItem -> Html.Html Msg
viewItem item =
    let
        checked =
            case item.completedAt of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    Html.div []
        [ Html.input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.checked checked
            , Html.Events.onCheck (ItemCheckedToggled item.itemId)
            ]
            []
        , Html.text item.name
        ]


posixCompare : Time.Posix -> Time.Posix -> Order
posixCompare a b =
    compare (Time.posixToMillis a) (Time.posixToMillis b)


sortByTimestamp : List Event.PinkItem -> List Event.PinkItem
sortByTimestamp items =
    List.sortBy
        (\a ->
            (a.createdAt |> Time.posixToMillis) * -1
        )
        items
