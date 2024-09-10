module Pages.Home_ exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.Button as Button
import Effect exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Lamdera
import Page exposing (Page)
import Ports
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = LogoutClicked


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        LogoutClicked ->
            ( model
            , Effect.logout
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Elm Land ❤️ Lamdera"
    , body =
        [ node "style" [] [ text """
            @import url('https://fonts.googleapis.com/css2?family=Lora:wght@600&family=Nunito+Sans&display=swap');

            html {
                height: 100%;
                color: white;
                background: linear-gradient(dodgerblue, #339);
            }
            body {
                display: flex;
                flex-direction: column;
                margin: 0;
                justify-content: center;
                align-items: center;
                height: 90vh;
                font-family: 'Lora';
            }
            h1 {
                margin: 0;
                font-weight: 600 !important;
            }
            """ ]
        , div [ style "display" "flex", style "gap" "1rem" ]
            [ img
                [ alt "Lando, the Elm Land Rainbow"
                , src "/lando.png"
                , style "width" "128px"
                , style "margin-right" "2.5rem"
                ]
                []
            , img
                [ alt "Laurie, the Lamdera Lambda Llamba"
                , src "/llama.png"
                , style "width" "81.4px"
                , style "margin-right" "1.5rem"
                , style "height" "108.4px"
                ]
                []
            ]
        , h1 [] [ text "Elm Land ❤️ Lamdera" ]
        , a [ Route.Path.href Route.Path.Lists ] [ text "Show Lists" ]
        , a [ Route.Path.href Route.Path.SetupKnown ] [ text "Connect other device" ]
        , Button.button "Logout" LogoutClicked |> Button.view
        ]
    }
