module Pages.Lists.ListId_.Edit.ItemId_ exposing (Model, Msg, page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Caption as Caption
import Components.Input as Input
import Components.Padding as Padding
import Components.Select as Select
import Components.Text as Text
import Components.Toggle as Toggle
import Dict
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Format
import Html
import Html.Attributes
import Html.Events
import ItemPriority exposing (ItemPriority, itemPriorityFromString, itemPriorityToString)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Time
import View exposing (View)


title =
    "Edit Item"


page : Auth.User -> Shared.Model -> Route { listId : String, itemId : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init shared route.params
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
    { itemName : String
    , initialItemName : String
    , itemChecked : Bool
    , initialItemChecked : Bool
    , itemPriority : ItemPriority
    , initialItemPriority : ItemPriority
    , listId : String
    , itemId : String
    , createdAt : Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    }


init : Shared.Model -> { listId : String, itemId : String } -> () -> ( Model, Effect Msg )
init shared params () =
    let
        item =
            shared.state.lists
                |> Dict.get params.listId
                |> Maybe.map .items
                |> Maybe.andThen (Dict.get params.itemId)

        itemName =
            item
                |> Maybe.map .name
                |> Maybe.withDefault ""

        itemChecked =
            item
                |> Maybe.map
                    (\i ->
                        case i.completedAt of
                            Just _ ->
                                True

                            Nothing ->
                                False
                    )
                |> Maybe.withDefault False

        createdAt =
            item
                |> Maybe.map .createdAt
                |> Maybe.withDefault (Time.millisToPosix 0)

        lastUpdatedAt =
            item
                |> Maybe.map .lastUpdatedAt
                |> Maybe.withDefault (Time.millisToPosix 0)

        numberOfUpdates =
            item
                |> Maybe.map .numberOfUpdates
                |> Maybe.withDefault 0

        priority =
            item
                |> Maybe.map .priority
                |> Maybe.withDefault ItemPriority.MediumItemPriority
    in
    ( { itemName = itemName
      , initialItemName = itemName
      , itemChecked = itemChecked
      , initialItemChecked = itemChecked
      , itemPriority = priority
      , initialItemPriority = priority
      , listId = params.listId
      , itemId = params.itemId
      , createdAt = createdAt
      , lastUpdatedAt = lastUpdatedAt
      , numberOfUpdates = numberOfUpdates
      }
    , Effect.none
    )


validate : Model -> Maybe String
validate model =
    if model.itemName == "" then
        Just "Name is required"

    else if not (hasChanged model) then
        Just "No changes made"

    else
        Nothing


hasChanged : Model -> Bool
hasChanged model =
    model.itemName
        /= model.initialItemName
        || model.itemChecked
        /= model.initialItemChecked
        || model.itemPriority
        /= model.initialItemPriority



-- UPDATE


type Msg
    = SaveClicked
    | NameChanged String
    | DoneClicked Bool
    | GotTimeForUpdatedItem Time.Posix
    | ItemPriorityChanged String


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        SaveClicked ->
            ( model, Effect.getTime GotTimeForUpdatedItem )

        NameChanged name ->
            ( { model | itemName = name }, Effect.none )

        DoneClicked checked ->
            ( { model | itemChecked = checked }, Effect.none )

        ItemPriorityChanged value ->
            ( { model | itemPriority = itemPriorityFromString value }, Effect.none )

        GotTimeForUpdatedItem timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    case EventMetadataHelper.createEventMetadata shared.nextIds (\ids -> model.listId) shared.user timestamp of
                        Ok eventMetadata ->
                            Ok eventMetadata

                        Err error ->
                            Err error

                newName =
                    if model.itemName == model.initialItemName then
                        Nothing

                    else
                        Just model.itemName

                newCompleted =
                    if model.itemChecked == model.initialItemChecked then
                        Nothing

                    else if model.itemChecked then
                        Just (Just timestamp)

                    else
                        -- Unchecked
                        Just Nothing

                newPriority =
                    if model.itemPriority == model.initialItemPriority then
                        Nothing

                    else
                        Just model.itemPriority
            in
            case eventResult of
                Ok eventMetadata ->
                    ( model
                    , Effect.batch
                        [ Effect.addEvent <|
                            Event.createItemUpdatedEvent eventMetadata
                                { itemId = model.itemId
                                , listId = model.listId
                                , name = newName
                                , completed = newCompleted
                                , itemPriority = newPriority
                                }
                        , Effect.replaceRoutePath (Route.Path.Lists_ListId_ { listId = model.listId })
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


view : Model -> View Msg
view model =
    { title = title
    , body =
        let
            saveButtonDisabled =
                case validate model of
                    Just _ ->
                        True

                    Nothing ->
                        False
        in
        [ AppBar.appBar
            |> AppBar.withContent
                [ Caption.caption2 "Editable" |> Caption.withLine True |> Caption.view
                , Padding.left
                    [ Input.text "Name" NameChanged Nothing model.itemName |> Input.view
                    , Toggle.toggle "Completed" DoneClicked model.itemChecked |> Toggle.view
                    , Select.select "Priority"
                        ItemPriorityChanged
                        ItemPriority.all
                        itemPriorityToString
                        model.itemPriority
                        |> Select.view
                    ]
                    |> Padding.view
                , Caption.caption2 "Fun facts" |> Caption.withLine True |> Caption.view
                , Padding.left
                    [ Text.keyValue "Created at" (model.createdAt |> Format.time) |> Text.view
                    , Text.keyValue "Last update at" (model.lastUpdatedAt |> Format.time) |> Text.view
                    , Text.keyValue "Number of updates" (model.numberOfUpdates |> String.fromInt) |> Text.view
                    ]
                    |> Padding.view
                ]
            |> AppBar.withActions
                [ Button.button "Update Item" SaveClicked
                    |> Button.withDisabled saveButtonDisabled
                    |> Button.view
                ]
            |> AppBar.view
        ]
    }
