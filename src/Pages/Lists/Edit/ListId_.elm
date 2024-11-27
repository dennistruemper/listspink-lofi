module Pages.Lists.Edit.ListId_ exposing (Model, Msg(..), page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Caption as Caption
import Components.Input as Input
import Components.KeyListener as KeyListener
import Components.Padding as Padding
import Components.QrCode as QrCode
import Components.Text as Text
import Dict
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Format
import Html
import Html.Attributes exposing (src)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Time
import Url
import View exposing (View)


title =
    "List Details"


page : Auth.User -> Shared.Model -> Route { listId : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init route.params.listId route shared
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
    , fullHostNameAndPort : String
    }


urlProtocolToString : Url.Protocol -> String
urlProtocolToString protocol =
    case protocol of
        Url.Http ->
            "http://"

        Url.Https ->
            "https://"


init : String -> Route { listId : String } -> Shared.Model -> () -> ( Model, Effect Msg )
init listId route shared () =
    ( { listId = listId
      , listName =
            shared.state.lists
                |> Dict.get listId
                |> Maybe.map .name
      , fullHostNameAndPort = (route.url.protocol |> urlProtocolToString) ++ route.url.host ++ ":" ++ (route.url.port_ |> Maybe.withDefault 443 |> String.fromInt)
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ListNameChanged String
    | UpdateListButtonClicked
    | GotTimeForUpdateList Time.Posix
    | CopyShareLinkClicked String


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

        CopyShareLinkClicked shareUrl ->
            ( model, Effect.copyToClipboard shareUrl )



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


onValidEnter : Model -> Html.Attribute Msg
onValidEnter model =
    KeyListener.onKeyUp
        (\key ->
            if
                key
                    == "Enter"
                    && validateListName model.listName
                    == Nothing
            then
                Just UpdateListButtonClicked

            else
                Nothing
        )


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
                let
                    shareUrl =
                        model.fullHostNameAndPort ++ (Route.Path.Share_ListId_ { listId = list.listId } |> Route.Path.toString)

                    qrCodeConfig =
                        QrCode.qrCode shareUrl
                            |> QrCode.withSize 250
                in
                AppBar.appBar
                    |> AppBar.withContent
                        [ Html.div
                            [ onValidEnter model ]
                            [ Caption.caption2 "Editable"
                                |> Caption.withLine True
                                |> Caption.view
                            , Padding.left
                                [ Input.text
                                    "List Name"
                                    ListNameChanged
                                    (validateListName model.listName)
                                    (model.listName |> Maybe.withDefault list.name)
                                    |> Input.view
                                ]
                                |> Padding.view
                            , Caption.caption2 "Share"
                                |> Caption.withLine True
                                |> Caption.view
                            , Padding.left
                                [ Html.details []
                                    [ Html.summary [] [ Html.text "Show QR Code" ]
                                    , QrCode.view qrCodeConfig
                                    ]
                                , Button.button "Copy share link" (CopyShareLinkClicked shareUrl)
                                    |> Button.view
                                ]
                                |> Padding.view
                            , Caption.caption2 "Fun facts"
                                |> Caption.withLine True
                                |> Caption.view
                            , Padding.left
                                [ Text.keyValue "Created at" (list.createdAt |> Format.time) |> Text.view
                                , Text.keyValue "Last update at" (list.lastUpdatedAt |> Format.time) |> Text.view
                                , Text.keyValue "Number of updates" (list.numberOfUpdates |> String.fromInt) |> Text.view
                                ]
                                |> Padding.view
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
