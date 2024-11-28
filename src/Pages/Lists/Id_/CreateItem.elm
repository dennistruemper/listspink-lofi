module Pages.Lists.Id_.CreateItem exposing (BatchMode(..), Model, Msg(..), page)

import Auth
import Browser.Dom as Dom
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Input as Input
import Components.KeyListener as KeyListener
import Components.Select as Select
import Components.Toast
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Html
import Html.Attributes
import Html.Events
import ItemPriority exposing (ItemPriority, itemPriorityFromString, itemPriorityToString)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Task
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
    , itemPriority : ItemPriority
    , error : Maybe String
    }


init : Route { id : String } -> () -> ( Model, Effect Msg )
init route () =
    ( { listId = route.params.id
      , itemName = ""
      , itemDescription = ""
      , itemPriority = ItemPriority.MediumItemPriority
      , error = Nothing
      }
    , Effect.generateIds
    )



-- UPDATE


type BatchMode
    = SingleItem
    | MultipleItems


type Msg
    = ItemNameChanged String
    | ItemDescriptionChanged String
    | CreateItemButtonClicked
    | CreateMoreButtonClicked
    | GotTimeForCreateItem BatchMode Time.Posix
    | ItemPriorityChanged String
    | NoOp
    | BackClicked


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )

        BackClicked ->
            ( model, Effect.pushRoutePath (Route.Path.Lists_ListId_ { listId = model.listId }) )

        ItemPriorityChanged newPriority ->
            ( { model | itemPriority = itemPriorityFromString newPriority }, Effect.none )

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
                    ( { model | error = Nothing }, Effect.getTime (GotTimeForCreateItem SingleItem) )

        CreateMoreButtonClicked ->
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
                    ( { model | error = Nothing }, Effect.getTime (GotTimeForCreateItem MultipleItems) )

        GotTimeForCreateItem batchMode timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    EventMetadataHelper.createEventMetadata shared.nextIds (\ids -> model.listId) shared.user timestamp
            in
            case eventResult of
                Ok eventMetadata ->
                    let
                        createItemEffect =
                            Effect.addEvent <|
                                Event.createItemCreatedEvent
                                    eventMetadata
                                    { itemName = model.itemName
                                    , itemId = shared.nextIds |> Maybe.map .itemId |> Maybe.withDefault ""
                                    , itemDescription =
                                        if String.isEmpty model.itemDescription then
                                            Nothing

                                        else
                                            Just model.itemDescription
                                    , itemPriority = Just model.itemPriority
                                    }

                        navigationEffect =
                            case batchMode of
                                SingleItem ->
                                    [ Effect.pushRoutePath (Route.Path.Lists_ListId_ { listId = model.listId }) ]

                                MultipleItems ->
                                    [ Effect.sendCmd (Task.attempt (\_ -> NoOp) (Dom.focus "item-name-input")) ]

                        baseEffects =
                            [ createItemEffect
                            , Effect.generateIds
                            , Effect.addToast (Components.Toast.success (model.itemName ++ " created"))
                            ]
                    in
                    ( { model
                        | itemName = ""
                        , itemDescription = ""
                      }
                    , Effect.batch (baseEffects ++ navigationEffect)
                    )

                Err error ->
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


onValidEnter : Model -> Html.Attribute Msg
onValidEnter model =
    KeyListener.onKeyUp
        (\key ->
            if key == "Enter" && validate model == Nothing then
                Just CreateMoreButtonClicked

            else
                Nothing
        )


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
            [ Html.div
                [ onValidEnter model ]
                [ Input.text "Name" ItemNameChanged (validateName model) model.itemName
                    |> Input.withId "item-name-input"
                    |> Input.view
                , Input.text "Description" ItemDescriptionChanged (validateDescription model) model.itemDescription |> Input.view
                , Select.select "Priority"
                    ItemPriorityChanged
                    ItemPriority.all
                    itemPriorityToString
                    model.itemPriority
                    |> Select.view
                , Html.br [] []
                , case model.error of
                    Just error ->
                        Html.text error

                    Nothing ->
                        Html.text ""
                ]
            ]
        |> AppBar.withActions
            [ Button.button "Back" BackClicked
                |> Button.view
            , Button.button "Create & Add More" CreateMoreButtonClicked
                |> Button.withDisabled buttonDisabled
                |> Button.view
            , Button.button "Create" CreateItemButtonClicked
                |> Button.withDisabled buttonDisabled
                |> Button.view
            ]
        |> AppBar.view
