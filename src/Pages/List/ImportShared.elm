module Pages.List.ImportShared exposing (Model, Msg, page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Caption as Caption
import Components.Input as Input
import Effect exposing (Effect)
import Html
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Url
import View exposing (View)


title : String
title =
    "Import Shared List"


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
    { value : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { value = "" }
    , Effect.none
    )



-- UPDATE


type Msg
    = InputChanged String
    | ImportClicked


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        InputChanged value ->
            ( { model | value = value }
            , Effect.none
            )

        ImportClicked ->
            let
                route =
                    Url.fromString model.value
                        |> Maybe.map Route.Path.fromUrl

                listId =
                    case route of
                        Just (Route.Path.Share_ListId_ props) ->
                            props.listId

                        _ ->
                            model.value
            in
            ( model
            , Effect.pushRoutePath (Route.Path.Share_ListId_ { listId = listId })
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
        [ AppBar.appBar
            |> AppBar.withContent
                [ Caption.caption2 "Enter the URL or Code of the shared list" |> Caption.view
                , Input.text "URL or Code" InputChanged Nothing model.value |> Input.view
                ]
            |> AppBar.withActions
                [ Button.button "Import" ImportClicked |> Button.view
                ]
            |> AppBar.view
        ]
    }
