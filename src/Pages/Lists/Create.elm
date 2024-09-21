module Pages.Lists.Create exposing (Model, Msg, page)

import Auth
import Bridge
import Effect exposing (Effect)
import Event exposing (EventDefinition)
import EventMetadataHelper
import Html
import Html.Attributes
import Html.Events
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import SortedEventList
import Task
import Time
import View exposing (View)


title =
    "Create List"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update shared
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout (toLayout user)


{-| Use the sidebar layout on this page
-}
toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold { caption = Just title }



-- INIT


type alias Model =
    { listName : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { listName = ""
      }
    , Effect.generateIds
    )



-- UPDATE


type Msg
    = ListNameChanged String
    | CreateListButtonClicked
    | GotTimeForCreateList Time.Posix


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ListNameChanged listName ->
            ( { model | listName = listName }
            , Effect.none
            )

        CreateListButtonClicked ->
            ( model, Effect.getTime GotTimeForCreateList )

        GotTimeForCreateList timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    case EventMetadataHelper.createEventMetadata shared.nextIds (\ids -> ids.listId) shared.user timestamp of
                        Ok eventMetadata ->
                            Ok eventMetadata

                        Err error ->
                            Err error
            in
            case eventResult of
                Ok eventMetadata ->
                    ( model, Effect.batch [ Effect.addEvent <| Event.createListCreatedEvent eventMetadata { name = model.listName, listId = eventMetadata.aggregateId }, Effect.back ] )

                Err error ->
                    --TODO
                    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = title
    , body =
        [ Html.input
            [ Html.Events.onInput ListNameChanged, Html.Attributes.placeholder "List name", Html.Attributes.value model.listName ]
            []
        , Html.button
            [ Html.Events.onClick CreateListButtonClicked, Html.Attributes.disabled (String.isEmpty model.listName) ]
            [ Html.text "Create List" ]
        ]
    }
