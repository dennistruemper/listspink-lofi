module Pages.Share.ListId_ exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.Button as Button
import Effect exposing (Effect)
import Html exposing (..)
import Lamdera
import Layouts
import Page exposing (Page)
import Process
import Route exposing (Route)
import Route.Path
import Shared
import Task
import Time
import View exposing (View)


title =
    "Share List"


type States
    = InitializingSync
    | Syncing
    | DoneSyncing
    | ErrorSyncing String


type alias Model =
    { listId : String
    , state : States
    }


page : Auth.User -> Shared.Model -> Route { listId : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init route.params.listId
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


init : String -> () -> ( Model, Effect Msg )
init listId _ =
    ( { listId = listId
      , state = InitializingSync
      }
    , Effect.batch
        [ Effect.sendCmd <| Lamdera.sendToBackend (Bridge.RequestListSubscription { listId = listId })
        , Effect.sendCmd <| (Process.sleep 5000 |> Task.perform (\_ -> TimeoutSubscriptionWait))
        ]
    )



-- UPDATE


type Msg
    = GotListSubscriptionAdded { userId : String, listId : String, timestamp : Time.Posix }
    | GotListSubscriptionFailed
    | TimeoutSubscriptionWait
    | GoBackClicked


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotListSubscriptionAdded data ->
            if data.listId == model.listId then
                ( { model
                    | state = Syncing
                  }
                , Effect.batch
                    [ Effect.sendCmd <| Lamdera.sendToBackend (Bridge.ReloadAllForAggregate { aggregateId = model.listId })
                    , Effect.replaceRoutePath Route.Path.Lists
                    ]
                )

            else
                ( model, Effect.none )

        GotListSubscriptionFailed ->
            ( { model | state = ErrorSyncing "Failed to subscribe to list. Please check the URL and try again." }
            , Effect.none
            )

        TimeoutSubscriptionWait ->
            case model.state of
                InitializingSync ->
                    ( { model | state = ErrorSyncing "Timeout waiting for subscription confirmation. Please check the URL and try again." }
                    , Effect.none
                    )

                _ ->
                    ( model, Effect.none )

        GoBackClicked ->
            ( model
            , Effect.replaceRoutePath Route.Path.List_ImportShared
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
        [ viewState model.state
        ]
    }


viewState : States -> Html Msg
viewState state =
    case state of
        InitializingSync ->
            text "Initializing sync"

        Syncing ->
            text "Syncing"

        DoneSyncing ->
            text "Done syncing"

        ErrorSyncing error ->
            div []
                [ div [] [ text error ]
                , Button.button "Go Back" GoBackClicked |> Button.view
                ]
