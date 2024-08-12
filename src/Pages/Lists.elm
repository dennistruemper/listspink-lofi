module Pages.Lists exposing (Model, Msg, page)

import Auth
import Bridge
import Dict
import Effect exposing (Effect)
import Event exposing (EventDefinition)
import Html
import Html.Events
import Page exposing (Page)
import Route exposing (Route)
import Shared
import SortedEventList
import Sync
import Time
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = CreateDummyList


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        CreateDummyList ->
            case shared.nextIds of
                Nothing ->
                    -- TODO
                    ( model, Effect.none )

                Just nextIds ->
                    let
                        event : Maybe EventDefinition
                        event =
                            shared.user
                                |> Maybe.map
                                    (\user ->
                                        case user of
                                            Bridge.Unknown ->
                                                Nothing

                                            Bridge.UserOnDevice userOnDeviceData ->
                                                Just userOnDeviceData.userId
                                    )
                                |> Maybe.map
                                    (\maybeUserId ->
                                        case maybeUserId of
                                            Nothing ->
                                                Nothing

                                            Just userId ->
                                                Just <|
                                                    Event.createListCreatedEvent
                                                        { eventId = nextIds.eventId, aggregateId = nextIds.listId, userId = userId, timestamp = Time.millisToPosix 0 }
                                                        { listId = nextIds.listId, name = "Dummy List" ++ (SortedEventList.length shared.syncModel.events |> String.fromInt) }
                                    )
                                |> Maybe.withDefault Nothing

                        effect =
                            case event of
                                Nothing ->
                                    Effect.none

                                Just evt ->
                                    Effect.addEvent evt
                    in
                    ( model
                    , Effect.batch [ Effect.generateIds, effect ]
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Pages.Lists"
    , body =
        [ Html.button [ Html.Events.onClick CreateDummyList ] [ Html.text "Create New Dummy List2" ]
        , viewLists shared
        ]
    }


viewLists : Shared.Model -> Html.Html Msg
viewLists shared =
    case Dict.values shared.state.lists of
        [] ->
            Html.text "No lists jet"

        lists ->
            Html.ul []
                (List.map
                    (\list ->
                        Html.li [] [ Html.text list.name, Html.text list.listId ]
                    )
                    lists
                )
