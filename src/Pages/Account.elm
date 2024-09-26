module Pages.Account exposing (Model, Msg(..), page)

import Auth
import Components.Button as Button
import Components.Column as Column
import Effect exposing (Effect)
import Html
import Html.Attributes
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


title =
    "Account"


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
    | LogoutClicked
    | ConnectDeviceClicked


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )

        LogoutClicked ->
            ( model
            , Effect.logout
            )

        ConnectDeviceClicked ->
            ( model
            , Effect.pushRoutePath Route.Path.SetupKnown
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
        [ Column.column
            [ Button.button "Connect other Device" ConnectDeviceClicked |> Button.view
            , Html.div [ Html.Attributes.class "grow" ] []
            , Button.button "Logout" LogoutClicked |> Button.view
            ]
            |> Column.withPadding Column.LargePadding
            |> Column.view
        ]
    }
