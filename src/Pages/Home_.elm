module Pages.Home_ exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.Button as Button
import Effect exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Lamdera
import Layouts
import Page exposing (Page)
import Ports
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


title =
    "Dashboard"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update
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
    { title = title
    , body =
        [ text "Welcome to Listspink" ]
    }
