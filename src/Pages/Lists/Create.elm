module Pages.Lists.Create exposing (Model, Msg(..), page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Input as Input
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


validateListName : Model -> Maybe String
validateListName model =
    if String.isEmpty model.listName then
        Just "List name cannot be empty"

    else
        Nothing


view : Model -> View Msg
view model =
    { title = title
    , body =
        [ AppBar.appBar
            |> AppBar.withContent
                [ Input.text "List name" ListNameChanged (validateListName model) model.listName |> Input.view
                ]
            |> AppBar.withActions
                [ Button.button "Create List" CreateListButtonClicked
                    |> Button.withDisabled (validateListName model /= Nothing)
                    |> Button.view
                ]
            |> AppBar.view
        ]
    }
