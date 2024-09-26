module Pages.Credits exposing (Model, Msg(..), page)

import Auth
import Components.Caption as Caption
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


title =
    "Credits"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
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


view : Model -> View Msg
view model =
    { title = title
    , body =
        [ div [ Html.Attributes.class "bg-fuchsia-200 grid lg:grid-cols-3 justify-items-center h-full items-center" ]
            [ a [ href "https://elm.land" ]
                [ Caption.caption2 "Elm Land" |> Caption.view
                , img
                    [ alt "Lando, the Elm Land Rainbow"
                    , src "/llama.png"
                    , class "max-w-48 max-h-48"
                    ]
                    []
                ]
            , Caption.caption2 "❤️" |> Caption.view
            , a [ href "https://lamdera.com" ]
                [ Caption.caption2 "Lamdera" |> Caption.view
                , img
                    [ alt "Laurie, the Lamdera Lambda Llamba"
                    , src "/lando.png"
                    , class "max-w-48 max-h-48"
                    ]
                    []
                ]
            ]
        ]
    }
