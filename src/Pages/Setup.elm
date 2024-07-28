module Pages.Setup exposing (Model, Msg, page)

import Bridge
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
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init route
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { redirect : Maybe String
    }


init : Route () -> () -> ( Model, Effect Msg )
init route () =
    ( { redirect = Dict.get "from" route.query }
    , Effect.none
    )



-- UPDATE


type Msg
    = CreateNewAccount
    | ConnectExistingAccount
    | Logout
    | ShowNewConnectionInfo
    | GotMessageFromJs String


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        CreateNewAccount ->
            ( model
            , Effect.pushRoutePath Route.Path.Setup_NewAccount
            )

        ConnectExistingAccount ->
            ( model
            , Effect.pushRoutePath Route.Path.Setup_Connect
            )

        ShowNewConnectionInfo ->
            ( model
            , Effect.batch [ Effect.pushRoutePath Route.Path.SetupKnown, Effect.sendCmd <| Lamdera.sendToBackend Bridge.GenerateSyncCode ]
            )

        Logout ->
            ( model, Effect.logout )

        GotMessageFromJs msgFromJs ->
            case Ports.decodeMsg msgFromJs of
                Ports.UserDataLoaded userData ->
                    let
                        redirectEffect =
                            case userData of
                                Bridge.Unknown ->
                                    Effect.none

                                Bridge.UserOnDevice user ->
                                    case model.redirect of
                                        Just from ->
                                            case Route.Path.fromString from of
                                                Just route ->
                                                    Effect.replaceRoutePath route

                                                Nothing ->
                                                    Effect.none

                                        Nothing ->
                                            Effect.none
                    in
                    ( model, redirectEffect )

                _ ->
                    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Ports.toElm GotMessageFromJs ]



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Setup Device"
    , body =
        [ case shared.user of
            Just user ->
                case user of
                    Bridge.UserOnDevice data ->
                        viewKnownUser data

                    Bridge.Unknown ->
                        viewUnknownUser

            Nothing ->
                viewNoUser
        ]
    }


viewUnknownUser : Html.Html Msg
viewUnknownUser =
    Html.div []
        [ Html.button [ Html.Events.onClick CreateNewAccount ] [ Html.text "Create New Account" ]
        , Html.br [] []
        , Html.br [] []
        , Html.button [ Html.Events.onClick ConnectExistingAccount ] [ Html.text "Connect Existing Account" ]
        ]


viewNoUser : Html.Html Msg
viewNoUser =
    Html.text "Waiting..."


viewKnownUser : Bridge.UserOnDeviceData -> Html.Html Msg
viewKnownUser user =
    Html.div []
        [ Html.text <| "Logged in as " ++ user.userName
        , Html.button [ Html.Events.onClick Logout ] [ Html.text "Logout" ]
        , Html.button [ Html.Events.onClick ShowNewConnectionInfo ] [ Html.text "Connect Another Device" ]
        ]
