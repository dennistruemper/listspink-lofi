module Pages.Lists exposing (Model, Msg, page)

import Auth
import Bridge
import Components.Button as Button
import Components.Column as Column
import Dict
import Effect exposing (Effect)
import Event exposing (EventDefinition)
import Html
import Html.Attributes
import Html.Events
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
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
        |> Page.withLayout (toLayout user)


{-| Use the sidebar layout on this page
-}
toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold {}



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
    | CreatNewListClicked


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

        CreatNewListClicked ->
            ( model
            , Effect.pushRoutePath Route.Path.Lists_Create
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
        [ Column.column
            [ Button.button "Create New Dummy List" CreateDummyList |> Button.view
            , Button.button "Create New List" CreatNewListClicked |> Button.view
            , viewLists shared
            ]
            |> Column.view
        ]
    }


viewLists : Shared.Model -> Html.Html Msg
viewLists shared =
    case Dict.values shared.state.lists of
        [] ->
            Html.text "No lists jet"

        lists ->
            Html.div []
                [ Html.text "Lists:"
                , Html.ul []
                    (List.map
                        (\list ->
                            Html.li [] [ Html.a [ Html.Attributes.href (Route.Path.Lists_ListId_ { listId = list.listId } |> Route.Path.toString) ] [ Html.text list.name ] ]
                        )
                        lists
                    )
                ]
