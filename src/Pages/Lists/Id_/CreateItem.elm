module Pages.Lists.Id_.CreateItem exposing (Model, Msg, page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Input as Input
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Html
import Html.Attributes
import Html.Events
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Time
import View exposing (View)


page : Auth.User -> Shared.Model -> Route { id : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init route
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }
        |> Page.withLayout (toLayout user)


{-| Use the sidebar layout on this page
-}
toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold { caption = Just "Create Item" }



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
                        , Effect.pushRoutePath (Route.Path.Lists_ListId_ { listId = model.listId })
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


validateName : Model -> Maybe String
validateName model =
    if String.isEmpty model.itemName then
        Just "Name is required"

    else
        Nothing


validateDescription : Model -> Maybe String
validateDescription model =
    Nothing


validate : Model -> Maybe String
validate model =
    case validateName model of
        Just error ->
            Just error

        Nothing ->
            case validateDescription model of
                Just error ->
                    Just error

                Nothing ->
                    Nothing


viewCreateItemForm : Shared.Model -> Model -> Html.Html Msg
viewCreateItemForm shared model =
    let
        buttonDisabled =
            case validate model of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    AppBar.appBar
        |> AppBar.withContent
            [ Input.text "Name" ItemNameChanged (validateName model) model.itemName |> Input.view
            , Input.text "Description" ItemDescriptionChanged (validateDescription model) model.itemDescription |> Input.view
            , Html.br [] []
            , case model.error of
                Just error ->
                    Html.text error

                Nothing ->
                    Html.text ""
            ]
        |> AppBar.withActions [ Button.button "Create" CreateItemButtonClicked |> Button.withDisabled buttonDisabled |> Button.view ]
        |> AppBar.view
