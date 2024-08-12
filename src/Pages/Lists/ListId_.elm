module Pages.Lists.ListId_ exposing (Model, Msg, page)

import Dict
import Effect exposing (Effect)
import Html
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route { listId : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route.params.listId
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { listId : String }


init : String -> () -> ( Model, Effect Msg )
init listId () =
    ( { listId = listId }
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
    let
        maybeList =
            shared.state.lists
                |> Dict.values
                |> List.filter (\l -> l.listId == model.listId)
                |> List.head
    in
    { title = "Pages.Lists.ListId_"
    , body =
        [ case maybeList of
            Just list ->
                Html.text list.name

            Nothing ->
                Html.text "List not found"
        ]
    }
