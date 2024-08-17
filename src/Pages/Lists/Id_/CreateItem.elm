module Pages.Lists.Id_.CreateItem exposing (Model, Msg, page)

import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Html
import Html.Attributes
import Html.Events
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Time
import View exposing (View)


page : Shared.Model -> Route { id : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { listId : String
    , itemName : String
    , itemDescription : String
    , error : Maybe String
    }


init : Route { id : String } -> () -> ( Model, Effect Msg )
init route () =
    ( { listId = route.params.id
      , itemName = ""
      , itemDescription = ""
      , error = Nothing
      }
    , Effect.generateIds
    )



-- UPDATE


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | GotTimeForCreateItem Time.Posix


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ItemNameChanged itemName ->
            ( { model | itemName = itemName }, Effect.none )

        ItemDescriptionChanged itemDescription ->
            ( { model | itemDescription = itemDescription }, Effect.none )

        CreateItemButtonClicked ->
            let
                error =
                    if String.isEmpty model.itemName then
                        Just "Name is required"

                    else
                        Nothing
            in
            case error of
                Just _ ->
                    ( { model | error = error }, Effect.none )

                Nothing ->
                    ( { model | error = Nothing }, Effect.getTime GotTimeForCreateItem )

        GotTimeForCreateItem timestamp ->
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
                    ( model
                    , Effect.batch
                        [ Effect.addEvent <|
                            Event.createItemCreatedEvent
                                eventMetadata
                                { itemName = model.itemName
                                , itemId = shared.nextIds |> Maybe.map (\ids -> ids.itemId) |> Maybe.withDefault ""
                                , itemDescription =
                                    if String.isEmpty model.itemDescription then
                                        Nothing

                                    else
                                        Just model.itemDescription
                                }
                        , Effect.back
                        ]
                    )

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
    { title = "Pages.Lists.Id_.CreateItem"
    , body = [ viewCreateItemForm shared model ]
    }


viewCreateItemForm : Shared.Model -> Model -> Html.Html Msg
viewCreateItemForm shared model =
    Html.div []
        [ Html.input [ Html.Events.onInput ItemNameChanged, Html.Attributes.value model.itemName, Html.Attributes.placeholder "Name" ] []
        , Html.input [ Html.Events.onInput ItemDescriptionChanged, Html.Attributes.value model.itemDescription, Html.Attributes.placeholder "Description" ] []
        , Html.button [ Html.Events.onClick CreateItemButtonClicked ] [ Html.text "Create" ]
        , Html.br [] []
        , case model.error of
            Just error ->
                Html.text error

            Nothing ->
                Html.text ""
        ]
