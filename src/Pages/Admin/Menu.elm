module Pages.Admin.Menu exposing (Model, Msg(..), page)

import Auth
import Bridge
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes
import Lamdera
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


title =
    "Admin Menu"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init user
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }


toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold { caption = Just title }



-- INIT


type alias Model =
    {}


init : Auth.User -> () -> ( Model, Effect Msg )
init user () =
    let
        redirectEfect =
            Auth.redirectIfNotAdmin user

        requestAdminDataEffect =
            Auth.ifAdminElse user (Effect.sendCmd <| Lamdera.sendToBackend Bridge.RequestAdminData) Effect.none
    in
    ( {}
    , Effect.batch [ redirectEfect, requestAdminDataEffect ]
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
        [ menuEntry Route.Path.Admin_Manual "Manual Page"
        ]
    }


menuEntry : Route.Path.Path -> String -> Html msg
menuEntry route name =
    Html.a
        [ Html.Attributes.href (Route.Path.toString route)
        , Html.Attributes.class "inline-flex items-center px-4 py-2 m-2 bg-fuchsia-600 hover:bg-fuchsia-700 text-white font-medium rounded-lg transition-colors"
        ]
        [ Html.text name ]
