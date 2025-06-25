module Pages.Lists.Edit.ListId_ exposing (Model, Msg(..), page)

import Auth
import Bridge
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
import Lamdera
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
    | UnsubscribeClicked
    | GotTimeForUnsubscribe Time.Posix


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

        UnsubscribeClicked ->
            ( model, Effect.getTime GotTimeForUnsubscribe )

        GotTimeForUnsubscribe timestamp ->
            let
                eventResult =
                    EventMetadataHelper.createEventMetadata
                        shared.nextIds
                        (\_ -> model.listId)
                        shared.user
                        timestamp
            in
            case eventResult of
                Ok eventMetadata ->
                    case shared.user of
                        Just user ->
                            case getUserId user of
                                Just userId ->
                                    ( model
                                    , Effect.batch
                                        [ Effect.addEvent <| Event.createListUnsharedWithUserEvent eventMetadata { userId = userId, listId = model.listId }
                                        , Effect.replaceRoutePath Route.Path.Lists
                                        ]
                                    )

                                Nothing ->
                                    ( model, Effect.none )

                        Nothing ->
                            ( model, Effect.none )

                Err _ ->
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
                |> Dict.get model.listId
    in
    { title = title
    , body =
        [ case maybeList of
            Just list ->
                -- Show the normal list edit content
                let
                    shareUrl =
                        model.fullHostNameAndPort ++ (Route.Path.Share_ListId_ { listId = list.listId } |> Route.Path.toString)

                    qrCodeConfig =
                        QrCode.qrCode shareUrl
                            |> QrCode.withSize 250

                    -- Check if current user can unsubscribe
                    canUnsubscribe =
                        case shared.user of
                            Just user ->
                                case getUserId user of
                                    Just userId ->
                                        List.member userId list.users || list.listId == userId

                                    Nothing ->
                                        False

                            Nothing ->
                                False
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
                        [ if canUnsubscribe then
                            Button.button "Leave List" UnsubscribeClicked |> Button.view

                          else
                            Html.text ""
                        , Button.button "Update List" UpdateListButtonClicked
                            |> Button.withDisabled
                                ((model.listName |> Maybe.withDefault "" |> String.isEmpty)
                                    || (model.listName |> Maybe.withDefault "")
                                    == list.name
                                )
                            |> Button.view
                        ]
                    |> AppBar.view

            Nothing ->
                -- List no longer exists or user doesn't have access
                Html.div
                    [ Html.Attributes.class "flex items-center justify-center min-h-screen"
                    ]
                    [ Html.div
                        [ Html.Attributes.class "text-center"
                        ]
                        [ Html.h2
                            [ Html.Attributes.class "text-lg font-medium text-gray-900 mb-2"
                            ]
                            [ Html.text "List Not Found" ]
                        , Html.p
                            [ Html.Attributes.class "text-sm text-gray-500 mb-4"
                            ]
                            [ Html.text "This list is no longer available or you don't have access to it." ]
                        , Html.a
                            [ Html.Attributes.href (Route.Path.Lists |> Route.Path.toString)
                            , Html.Attributes.class "text-fuchsia-600 hover:text-fuchsia-500"
                            ]
                            [ Html.text "Go back to lists" ]
                        ]
                    ]
        ]
    }


getUserId : Bridge.User -> Maybe String
getUserId user =
    case user of
        Bridge.Unknown ->
            Nothing

        Bridge.UserOnDevice userData ->
            Just userData.userId
