module Pages.SetupKnown exposing (Model, Msg, page)

import Bridge
import Effect exposing (Effect)
import Html
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
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
    , Effect.sendCmd <| Lamdera.sendToBackend Bridge.GenerateSyncCode
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
    let
        code =
            shared.syncCode |> Maybe.map String.fromInt |> Maybe.withDefault "Waiting for code..."
    in
    { title = "Pages.Setup"
    , body = [ Html.text code ]
    }
