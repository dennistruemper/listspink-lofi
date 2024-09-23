module Pages.Lists.Edit.ListId_ exposing (Model, Msg, page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Caption as Caption
import Components.Input as Input
import Dict
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Format
import Html
import Html.Attributes
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Time
import View exposing (View)


title =
    "List Details"


page : Auth.User -> Shared.Model -> Route { listId : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init route.params.listId shared
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }
        |> Page.withLayout (toLayout user)


{-| Use the sidebar layout on this page
-}
toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold { caption = Just title }



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
                |> Dict.get listId
                |> Maybe.map .name
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ListNameChanged String
    | UpdateListButtonClicked
    | GotTimeForUpdateList Time.Posix


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
                            ( model
                            , Effect.batch
                                [ Effect.addEvent <| Event.createListUpdatedEvent eventMetadata { name = listName }
                                , Effect.replaceRoutePath Route.Path.Lists
                                ]
                            )

                        -- todo handle error
                        Nothing ->
                            ( model, Effect.batch [] )

                Err error ->
                    --TODO
                    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


validateListName : Maybe String -> Maybe String
validateListName maybeListName =
    case maybeListName of
        Just listName ->
            if String.isEmpty listName then
                Just "List name cannot be empty"

            else
                Nothing

        Nothing ->
            Just "List name cannot be empty"



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
    { title = title
    , body =
        [ case maybeList of
            Just list ->
                AppBar.appBar
                    |> AppBar.withContent
                        [ Caption.caption2 "Editable"
                            |> Caption.withLine True
                            |> Caption.view
                        , Html.div [ Html.Attributes.class "pl-2 lg:pl-4" ]
                            [ Input.text
                                "List Name"
                                ListNameChanged
                                (validateListName model.listName)
                                (model.listName |> Maybe.withDefault list.name)
                                |> Input.view
                            ]
                        , Caption.caption2 "Fun facts"
                            |> Caption.withLine True
                            |> Caption.view
                        , Html.div [ Html.Attributes.class "pl-2 lg:pl-4" ]
                            [ Html.p [ Html.Attributes.class " flex flex-row w-full justify-between" ] [ Html.p [ Html.Attributes.class "font-semibold" ] [ Html.text "Created at:" ], Html.text (list.createdAt |> Format.time) ]
                            , Html.p [ Html.Attributes.class " flex flex-row w-full justify-between" ] [ Html.p [ Html.Attributes.class "font-semibold" ] [ Html.text "Last update at:" ], Html.text (list.lastUpdatedAt |> Format.time) ]
                            , Html.p [ Html.Attributes.class " flex flex-row w-full justify-between" ] [ Html.p [ Html.Attributes.class "font-semibold" ] [ Html.text "Number of updates:" ], Html.text (list.numberOfUpdates |> String.fromInt) ]
                            ]
                        ]
                    |> AppBar.withActions
                        [ Button.button "Update List" UpdateListButtonClicked
                            |> Button.withDisabled
                                ((model.listName |> Maybe.withDefault "" |> String.isEmpty)
                                    || (model.listName |> Maybe.withDefault "")
                                    == list.name
                                )
                            |> Button.view
                        ]
                    |> AppBar.view

            Nothing ->
                Html.text "List not found"
        ]
    }
