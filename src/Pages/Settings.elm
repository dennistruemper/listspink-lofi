module Pages.Settings exposing (Model, Msg(..), page)

import Auth
import Components.Text
import Effect exposing (Effect)
import Html
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


title =
    "Settings"


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
init () =
    ( {}
    , Effect.none
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
    { title = title
    , body =
        [ case shared.version of
            Just version ->
                Html.text <| "Version: " ++ version

            Nothing ->
                Html.div [] []
        ]
    }
