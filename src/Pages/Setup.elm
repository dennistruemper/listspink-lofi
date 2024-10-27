module Pages.Setup exposing (Model, Msg(..), page)

import Bridge
import Components.Button as Button
import Components.Caption as Caption
import Components.Column as Column
import Components.LoadingSpinner as LoadingSpinner
import Dict
import Effect exposing (Effect)
import Html
import Html.Attributes
import Html.Events
import Lamdera
import Page exposing (Page)
import Ports
import Route exposing (Route)
import Route.Path
import Shared
import Time
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init shared route
        , update = update shared route
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { redirect : Maybe String
    , initialUserdata : Maybe Bridge.User
    }


init : Shared.Model -> Route () -> () -> ( Model, Effect Msg )
init shared route () =
    ( { redirect = Dict.get "from" route.query, initialUserdata = Nothing }
    , Effect.none
    )



-- UPDATE


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotTime Time.Posix
    | NoOp


update : Shared.Model -> Route () -> Msg -> Model -> ( Model, Effect Msg )
update shared route msg model =
    case msg of
        GotTime time ->
            case ( model.initialUserdata, shared.user ) of
                ( Nothing, Just (Bridge.UserOnDevice _) ) ->
                    let
                        redirect =
                            case model.redirect of
                                Just from ->
                                    case Route.Path.fromString from of
                                        Just newRoute ->
                                            Effect.replaceRoutePath newRoute

                                        Nothing ->
                                            Effect.none

                                Nothing ->
                                    Effect.none
                    in
                    ( model, redirect )

                _ ->
                    ( model, Effect.none )

        CreateNewAccount ->
            ( model
            , Effect.pushRoute { path = Route.Path.Setup_NewAccount, hash = Nothing, query = route.query }
            )

        ConnectExistingAccount ->
            ( model
            , Effect.pushRoute { path = Route.Path.Setup_Connect, hash = Nothing, query = route.query }
            )

        ShowNewConnectionInfo ->
            ( model
            , Effect.batch [ Effect.pushRoutePath Route.Path.SetupKnown, Effect.sendCmd <| Lamdera.sendToBackend Bridge.GenerateSyncCode ]
            )

        Logout ->
            ( model, Effect.logout )

        NoOp ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Time.every 500 GotTime ]


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Setup Device"
    , body =
        [ case shared.user of
            Just (Bridge.UserOnDevice data) ->
                if model.initialUserdata == Nothing then
                    LoadingSpinner.view

                else
                    viewKnownUser data

            Just Bridge.Unknown ->
                viewUnknownUser

            Nothing ->
                viewNoUser
        ]
    }


viewUnknownUser : Html.Html Msg
viewUnknownUser =
    Column.column
        [ Html.p [] [ Html.text "Please choose one of the following options:" ]
        , Button.button "Create New Account" CreateNewAccount |> Button.view
        , Button.button "Connect Existing Account" ConnectExistingAccount |> Button.view
        ]
        |> Column.withPadding Column.LargePadding
        |> Column.view


viewNoUser : Html.Html Msg
viewNoUser =
    Html.text "Waiting..."


viewKnownUser : Bridge.UserOnDeviceData -> Html.Html Msg
viewKnownUser user =
    Html.div []
        [ Column.column
            [ Html.text <| "Logged in as " ++ user.userName
            , Button.button "Logout" Logout |> Button.view
            , Button.button "Connect Another Device" ShowNewConnectionInfo |> Button.view
            ]
            |> Column.view
        ]
