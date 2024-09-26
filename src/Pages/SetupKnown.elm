module Pages.SetupKnown exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.Caption as Caption
import Components.Center as Center
import Components.Column as Column
import Effect exposing (Effect)
import Html
import Html.Attributes
import Lamdera
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


title =
    "Setup Other Device"


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
    { title = title
    , body =
        [ Column.column
            [ Center.center
                [ Html.p
                    []
                    [ Html.text "To sync with another device, execute the following steps:"
                    , Html.ol [ Html.Attributes.class "list-decimal pt-4" ]
                        [ Html.li [] [ Html.text "Open the app on the other device" ]
                        , Html.li [] [ Html.text "Go to \"Connect Existing Account\"" ]
                        , Html.li [] [ Html.text "Enter the code below and your name for the device" ]
                        ]
                    ]
                , Caption.caption2
                    code
                    |> Caption.view
                ]
                |> Center.withPadding Center.LargePadding
                |> Center.view
            ]
            |> Column.withPadding Column.LargePadding
            |> Column.view
        ]
    }
