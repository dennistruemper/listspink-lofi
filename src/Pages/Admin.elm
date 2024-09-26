module Pages.Admin exposing (Model, Msg(..), page)

import Auth
import Bridge
import Effect exposing (Effect)
import Html
import Html.Attributes
import Lamdera
import Page exposing (Page)
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
init () =
    ( {}
    , Effect.sendCmd <| Lamdera.sendToBackend Bridge.RequestAdminData
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Pages.Admin"
    , body =
        [ Html.a [ Html.Attributes.href (Route.Path.toString Route.Path.Manual) ]
            [ Html.text "Manual Page" ]
        , Html.text
            "TODO"
        ]
    }
