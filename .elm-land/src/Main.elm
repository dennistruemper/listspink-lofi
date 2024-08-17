module Main exposing (..)

import Auth
import Auth.Action
import Browser
import Browser.Navigation
import Effect exposing (Effect)
import Html exposing (Html)
import Json.Decode
import Layout
import Layouts
import Main.Layouts.Model
import Main.Layouts.Msg
import Main.Pages.Model
import Main.Pages.Msg
import Page
import Pages.Home_
import Pages.Admin
import Pages.Lists
import Pages.Lists.Create
import Pages.Lists.Id_.CreateItem
import Pages.Lists.ListId_
import Pages.Manual
import Pages.Setup
import Pages.Setup.Connect
import Pages.Setup.NewAccount
import Pages.SetupKnown
import Pages.NotFound_
import Pages.NotFound_
import Route exposing (Route)
import Route.Path
import Shared
import Task
import Url exposing (Url)
import View exposing (View)


main : Program Json.Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }



-- INIT


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url
    , page : Main.Pages.Model.Model
    , layout : Maybe Main.Layouts.Model.Model
    , shared : Shared.Model
    }


init : Json.Decode.Value -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init json url key =
    let
        flagsResult : Result Json.Decode.Error Shared.Flags
        flagsResult =
            Json.Decode.decodeValue Shared.decoder json

        ( sharedModel, sharedEffect ) =
            Shared.init flagsResult (Route.fromUrl () url)

        { page, layout } =
            initPageAndLayout { key = key, url = url, shared = sharedModel, layout = Nothing }
    in
    ( { url = url
      , key = key
      , page = Tuple.first page
      , layout = layout |> Maybe.map Tuple.first
      , shared = sharedModel
      }
    , Cmd.batch
          [ Tuple.second page
          , layout |> Maybe.map Tuple.second |> Maybe.withDefault Cmd.none
          , fromSharedEffect { key = key, url = url, shared = sharedModel } sharedEffect
          ]
    )


initPageAndLayout : { key : Browser.Navigation.Key, url : Url, shared : Shared.Model, layout : Maybe Main.Layouts.Model.Model } -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }
initPageAndLayout model =
    case Route.Path.fromUrl model.url of
        Route.Path.Home_ ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Home_.Model Pages.Home_.Msg
                        page =
                            Pages.Home_.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Home_
                            (Effect.map Main.Pages.Msg.Home_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = Nothing
                    }
                )

        Route.Path.Admin ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Admin.Model Pages.Admin.Msg
                        page =
                            Pages.Admin.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Admin
                            (Effect.map Main.Pages.Msg.Admin >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = Nothing
                    }
                )

        Route.Path.Lists ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.Model Pages.Lists.Msg
                        page =
                            Pages.Lists.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Lists
                            (Effect.map Main.Pages.Msg.Lists >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = Nothing
                    }
                )

        Route.Path.Lists_Create ->
            let
                page : Page.Page Pages.Lists.Create.Model Pages.Lists.Create.Msg
                page =
                    Pages.Lists.Create.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.Lists_Create
                    (Effect.map Main.Pages.Msg.Lists_Create >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Lists_Id__CreateItem params ->
            let
                page : Page.Page Pages.Lists.Id_.CreateItem.Model Pages.Lists.Id_.CreateItem.Msg
                page =
                    Pages.Lists.Id_.CreateItem.page model.shared (Route.fromUrl params model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    (Main.Pages.Model.Lists_Id__CreateItem params)
                    (Effect.map Main.Pages.Msg.Lists_Id__CreateItem >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Lists_ListId_ params ->
            let
                page : Page.Page Pages.Lists.ListId_.Model Pages.Lists.ListId_.Msg
                page =
                    Pages.Lists.ListId_.page model.shared (Route.fromUrl params model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    (Main.Pages.Model.Lists_ListId_ params)
                    (Effect.map Main.Pages.Msg.Lists_ListId_ >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Manual ->
            let
                page : Page.Page Pages.Manual.Model Pages.Manual.Msg
                page =
                    Pages.Manual.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.Manual
                    (Effect.map Main.Pages.Msg.Manual >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Setup ->
            let
                page : Page.Page Pages.Setup.Model Pages.Setup.Msg
                page =
                    Pages.Setup.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.Setup
                    (Effect.map Main.Pages.Msg.Setup >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Setup_Connect ->
            let
                page : Page.Page Pages.Setup.Connect.Model Pages.Setup.Connect.Msg
                page =
                    Pages.Setup.Connect.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.Setup_Connect
                    (Effect.map Main.Pages.Msg.Setup_Connect >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.Setup_NewAccount ->
            let
                page : Page.Page Pages.Setup.NewAccount.Model Pages.Setup.NewAccount.Msg
                page =
                    Pages.Setup.NewAccount.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.Setup_NewAccount
                    (Effect.map Main.Pages.Msg.Setup_NewAccount >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.SetupKnown ->
            let
                page : Page.Page Pages.SetupKnown.Model Pages.SetupKnown.Msg
                page =
                    Pages.SetupKnown.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.SetupKnown
                    (Effect.map Main.Pages.Msg.SetupKnown >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }

        Route.Path.NotFound_ ->
            let
                page : Page.Page Pages.NotFound_.Model Pages.NotFound_.Msg
                page =
                    Pages.NotFound_.page model.shared (Route.fromUrl () model.url)

                ( pageModel, pageEffect ) =
                    Page.init page ()
            in
            { page = 
                Tuple.mapBoth
                    Main.Pages.Model.NotFound_
                    (Effect.map Main.Pages.Msg.NotFound_ >> fromPageEffect model)
                    ( pageModel, pageEffect )
            , layout = Nothing
            }


runWhenAuthenticated : { model | shared : Shared.Model, url : Url, key : Browser.Navigation.Key } -> (Auth.User -> ( Main.Pages.Model.Model, Cmd Msg )) -> ( Main.Pages.Model.Model, Cmd Msg )
runWhenAuthenticated model toTuple =
    let
        record =
            runWhenAuthenticatedWithLayout model (\user -> { page = toTuple user, layout = Nothing })
    in
    record.page


runWhenAuthenticatedWithLayout : { model | shared : Shared.Model, url : Url, key : Browser.Navigation.Key } -> (Auth.User -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }) -> { page : ( Main.Pages.Model.Model, Cmd Msg ), layout : Maybe ( Main.Layouts.Model.Model, Cmd Msg ) }
runWhenAuthenticatedWithLayout model toRecord =
    let
        authAction : Auth.Action.Action Auth.User
        authAction =
            Auth.onPageLoad model.shared (Route.fromUrl () model.url)

        toCmd : Effect Msg -> Cmd Msg
        toCmd =
            Effect.toCmd
                { key = model.key
                , url = model.url
                , shared = model.shared
                , fromSharedMsg = Shared
                , batch = Batch
                , toCmd = Task.succeed >> Task.perform identity
                }
    in
    case authAction of
        Auth.Action.LoadPageWithUser user ->
            toRecord user

        Auth.Action.LoadCustomPage ->
            { page = 
                ( Main.Pages.Model.Loading_
                , Cmd.none
                )
            , layout = Nothing
            }

        Auth.Action.ReplaceRoute options ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , toCmd (Effect.replaceRoute options)
                )
            , layout = Nothing
            }

        Auth.Action.PushRoute options ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , toCmd (Effect.pushRoute options)
                )
            , layout = Nothing
            }

        Auth.Action.LoadExternalUrl externalUrl ->
            { page = 
                ( Main.Pages.Model.Redirecting_
                , Browser.Navigation.load externalUrl
                )
            , layout = Nothing
            }



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | Page Main.Pages.Msg.Msg
    | Layout Main.Layouts.Msg.Msg
    | Shared Shared.Msg
    | Batch (List Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested (Browser.Internal url) ->
            ( model
            , Browser.Navigation.pushUrl model.key (Url.toString url)
            )

        UrlRequested (Browser.External url) ->
            if String.isEmpty (String.trim url) then
                ( model, Cmd.none )

            else
                ( model
                , Browser.Navigation.load url
                )

        UrlChanged url ->
            if Route.Path.fromUrl url == Route.Path.fromUrl model.url then
                let
                    newModel : Model
                    newModel =
                        { model | url = url }
                in
                ( newModel
                , Cmd.batch
                      [ toPageUrlHookCmd newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      , toLayoutUrlHookCmd model newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      ]
                )

            else
                let
                    { page, layout } =
                        initPageAndLayout { key = model.key, shared = model.shared, layout = model.layout, url = url }

                    ( pageModel, pageCmd ) =
                        page

                    ( layoutModel, layoutCmd ) =
                        case layout of
                            Just ( layoutModel_, layoutCmd_ ) ->
                                ( Just layoutModel_, layoutCmd_ )

                            Nothing ->
                                ( Nothing, Cmd.none )

                    newModel =
                        { model | url = url, page = pageModel, layout = layoutModel }
                in
                ( newModel
                , Cmd.batch
                      [ pageCmd
                      , layoutCmd
                      , toLayoutUrlHookCmd model newModel
                            { from = Route.fromUrl () model.url
                            , to = Route.fromUrl () newModel.url
                            }
                      ]
                )

        Page pageMsg ->
            let
                ( pageModel, pageCmd ) =
                    updateFromPage pageMsg model
            in
            ( { model | page = pageModel }
            , pageCmd
            )

        Layout layoutMsg ->
            let
                ( layoutModel, layoutCmd ) =
                    updateFromLayout layoutMsg model
            in
            ( { model | layout = layoutModel }
            , layoutCmd
            )

        Shared sharedMsg ->
            let
                ( sharedModel, sharedEffect ) =
                    Shared.update (Route.fromUrl () model.url) sharedMsg model.shared

                ( oldAction, newAction ) =
                    ( Auth.onPageLoad model.shared (Route.fromUrl () model.url)
                    , Auth.onPageLoad sharedModel (Route.fromUrl () model.url)
                    )
            in
            if isAuthProtected (Route.fromUrl () model.url).path && (hasActionTypeChanged oldAction newAction) then
                let
                    { layout, page } =
                        initPageAndLayout { key = model.key, shared = sharedModel, url = model.url, layout = model.layout }

                    ( pageModel, pageCmd ) =
                        page

                    ( layoutModel, layoutCmd ) =
                        ( layout |> Maybe.map Tuple.first
                        , layout |> Maybe.map Tuple.second |> Maybe.withDefault Cmd.none
                        )
                in
                ( { model | shared = sharedModel, page = pageModel, layout = layoutModel }
                , Cmd.batch
                      [ pageCmd
                      , layoutCmd
                      , fromSharedEffect { model | shared = sharedModel } sharedEffect
                      ]
                )

            else
                ( { model | shared = sharedModel }
                , fromSharedEffect { model | shared = sharedModel } sharedEffect
                )

        Batch messages ->
            ( model
            , messages
                  |> List.map (Task.succeed >> Task.perform identity)
                  |> Cmd.batch
            )


updateFromPage : Main.Pages.Msg.Msg -> Model -> ( Main.Pages.Model.Model, Cmd Msg )
updateFromPage msg model =
    case ( msg, model.page ) of
        ( Main.Pages.Msg.Home_ pageMsg, Main.Pages.Model.Home_ pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Home_
                        (Effect.map Main.Pages.Msg.Home_ >> fromPageEffect model)
                        (Page.update (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Admin pageMsg, Main.Pages.Model.Admin pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Admin
                        (Effect.map Main.Pages.Msg.Admin >> fromPageEffect model)
                        (Page.update (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists pageMsg, Main.Pages.Model.Lists pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Lists
                        (Effect.map Main.Pages.Msg.Lists >> fromPageEffect model)
                        (Page.update (Pages.Lists.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists_Create pageMsg, Main.Pages.Model.Lists_Create pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Lists_Create
                (Effect.map Main.Pages.Msg.Lists_Create >> fromPageEffect model)
                (Page.update (Pages.Lists.Create.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Lists_Id__CreateItem pageMsg, Main.Pages.Model.Lists_Id__CreateItem params pageModel ) ->
            Tuple.mapBoth
                (Main.Pages.Model.Lists_Id__CreateItem params)
                (Effect.map Main.Pages.Msg.Lists_Id__CreateItem >> fromPageEffect model)
                (Page.update (Pages.Lists.Id_.CreateItem.page model.shared (Route.fromUrl params model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Lists_ListId_ pageMsg, Main.Pages.Model.Lists_ListId_ params pageModel ) ->
            Tuple.mapBoth
                (Main.Pages.Model.Lists_ListId_ params)
                (Effect.map Main.Pages.Msg.Lists_ListId_ >> fromPageEffect model)
                (Page.update (Pages.Lists.ListId_.page model.shared (Route.fromUrl params model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Manual pageMsg, Main.Pages.Model.Manual pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Manual
                (Effect.map Main.Pages.Msg.Manual >> fromPageEffect model)
                (Page.update (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Setup pageMsg, Main.Pages.Model.Setup pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Setup
                (Effect.map Main.Pages.Msg.Setup >> fromPageEffect model)
                (Page.update (Pages.Setup.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Setup_Connect pageMsg, Main.Pages.Model.Setup_Connect pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Setup_Connect
                (Effect.map Main.Pages.Msg.Setup_Connect >> fromPageEffect model)
                (Page.update (Pages.Setup.Connect.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Setup_NewAccount pageMsg, Main.Pages.Model.Setup_NewAccount pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Setup_NewAccount
                (Effect.map Main.Pages.Msg.Setup_NewAccount >> fromPageEffect model)
                (Page.update (Pages.Setup.NewAccount.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.SetupKnown pageMsg, Main.Pages.Model.SetupKnown pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.SetupKnown
                (Effect.map Main.Pages.Msg.SetupKnown >> fromPageEffect model)
                (Page.update (Pages.SetupKnown.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.NotFound_ pageMsg, Main.Pages.Model.NotFound_ pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.NotFound_
                (Effect.map Main.Pages.Msg.NotFound_ >> fromPageEffect model)
                (Page.update (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        _ ->
            ( model.page
            , Cmd.none
            )


updateFromLayout : Main.Layouts.Msg.Msg -> Model -> ( Maybe Main.Layouts.Model.Model, Cmd Msg )
updateFromLayout msg model =
    let
        route : Route ()
        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout, msg ) of
        _ ->
            ( model.layout
            , Cmd.none
            )


toLayoutFromPage : Model -> Maybe (Layouts.Layout Msg)
toLayoutFromPage model =
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Home_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Home_ >> Page))

        Main.Pages.Model.Admin pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin >> Page))

        Main.Pages.Model.Lists pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Lists.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists >> Page))

        Main.Pages.Model.Lists_Create pageModel ->
            Route.fromUrl () model.url
                |> Pages.Lists.Create.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Create >> Page))

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Route.fromUrl params model.url
                |> Pages.Lists.Id_.CreateItem.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Id__CreateItem >> Page))

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Route.fromUrl params model.url
                |> Pages.Lists.ListId_.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_ListId_ >> Page))

        Main.Pages.Model.Manual pageModel ->
            Route.fromUrl () model.url
                |> Pages.Manual.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Manual >> Page))

        Main.Pages.Model.Setup pageModel ->
            Route.fromUrl () model.url
                |> Pages.Setup.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup >> Page))

        Main.Pages.Model.Setup_Connect pageModel ->
            Route.fromUrl () model.url
                |> Pages.Setup.Connect.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup_Connect >> Page))

        Main.Pages.Model.Setup_NewAccount pageModel ->
            Route.fromUrl () model.url
                |> Pages.Setup.NewAccount.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup_NewAccount >> Page))

        Main.Pages.Model.SetupKnown pageModel ->
            Route.fromUrl () model.url
                |> Pages.SetupKnown.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.SetupKnown >> Page))

        Main.Pages.Model.NotFound_ pageModel ->
            Route.fromUrl () model.url
                |> Pages.NotFound_.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.NotFound_ >> Page))

        Main.Pages.Model.Redirecting_ ->
            Nothing

        Main.Pages.Model.Loading_ ->
            Nothing


toAuthProtectedPage : Model -> (Auth.User -> Shared.Model -> Route params -> Page.Page model msg) -> Route params -> Maybe (Page.Page model msg)
toAuthProtectedPage model toPage route =
    case Auth.onPageLoad model.shared (Route.fromUrl () model.url) of
        Auth.Action.LoadPageWithUser user ->
            Just (toPage user model.shared route)

        _ ->
            Nothing


hasActionTypeChanged : Auth.Action.Action user -> Auth.Action.Action user -> Bool
hasActionTypeChanged oldAction newAction =
    case ( newAction, oldAction ) of
        ( Auth.Action.LoadPageWithUser _, Auth.Action.LoadPageWithUser _ ) ->
            False

        ( Auth.Action.LoadCustomPage, Auth.Action.LoadCustomPage ) ->
            False

        ( Auth.Action.ReplaceRoute _, Auth.Action.ReplaceRoute _ ) ->
            False

        ( Auth.Action.PushRoute _, Auth.Action.PushRoute _ ) ->
            False

        ( Auth.Action.LoadExternalUrl _, Auth.Action.LoadExternalUrl _ ) ->
            False

        ( _,  _ ) ->
            True


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subscriptionsFromPage : Sub Msg
        subscriptionsFromPage =
            case model.page of
                Main.Pages.Model.Home_ pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Home_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Admin pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Admin
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists_Create pageModel ->
                    Page.subscriptions (Pages.Lists.Create.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Lists_Create
                        |> Sub.map Page

                Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
                    Page.subscriptions (Pages.Lists.Id_.CreateItem.page model.shared (Route.fromUrl params model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Lists_Id__CreateItem
                        |> Sub.map Page

                Main.Pages.Model.Lists_ListId_ params pageModel ->
                    Page.subscriptions (Pages.Lists.ListId_.page model.shared (Route.fromUrl params model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Lists_ListId_
                        |> Sub.map Page

                Main.Pages.Model.Manual pageModel ->
                    Page.subscriptions (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Manual
                        |> Sub.map Page

                Main.Pages.Model.Setup pageModel ->
                    Page.subscriptions (Pages.Setup.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Setup
                        |> Sub.map Page

                Main.Pages.Model.Setup_Connect pageModel ->
                    Page.subscriptions (Pages.Setup.Connect.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Setup_Connect
                        |> Sub.map Page

                Main.Pages.Model.Setup_NewAccount pageModel ->
                    Page.subscriptions (Pages.Setup.NewAccount.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Setup_NewAccount
                        |> Sub.map Page

                Main.Pages.Model.SetupKnown pageModel ->
                    Page.subscriptions (Pages.SetupKnown.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.SetupKnown
                        |> Sub.map Page

                Main.Pages.Model.NotFound_ pageModel ->
                    Page.subscriptions (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.NotFound_
                        |> Sub.map Page

                Main.Pages.Model.Redirecting_ ->
                    Sub.none

                Main.Pages.Model.Loading_ ->
                    Sub.none

        maybeLayout : Maybe (Layouts.Layout Msg)
        maybeLayout =
            toLayoutFromPage model

        route : Route ()
        route =
            Route.fromUrl () model.url

        subscriptionsFromLayout : Sub Msg
        subscriptionsFromLayout =
            case ( maybeLayout, model.layout ) of
                _ ->
                    Sub.none
    in
    Sub.batch
        [ Shared.subscriptions route model.shared
              |> Sub.map Shared
        , subscriptionsFromPage
        , subscriptionsFromLayout
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        view_ : View Msg
        view_ =
            toView model
    in
    View.toBrowserDocument
        { shared = model.shared
        , route = Route.fromUrl () model.url
        , view = view_
        }


toView : Model -> View Msg
toView model =
    viewPage model


viewPage : Model -> View Msg
viewPage model =
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Home_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Admin
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Create pageModel ->
            Page.view (Pages.Lists.Create.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Lists_Create
                |> View.map Page

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Page.view (Pages.Lists.Id_.CreateItem.page model.shared (Route.fromUrl params model.url)) pageModel
                |> View.map Main.Pages.Msg.Lists_Id__CreateItem
                |> View.map Page

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Page.view (Pages.Lists.ListId_.page model.shared (Route.fromUrl params model.url)) pageModel
                |> View.map Main.Pages.Msg.Lists_ListId_
                |> View.map Page

        Main.Pages.Model.Manual pageModel ->
            Page.view (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Manual
                |> View.map Page

        Main.Pages.Model.Setup pageModel ->
            Page.view (Pages.Setup.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Setup
                |> View.map Page

        Main.Pages.Model.Setup_Connect pageModel ->
            Page.view (Pages.Setup.Connect.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Setup_Connect
                |> View.map Page

        Main.Pages.Model.Setup_NewAccount pageModel ->
            Page.view (Pages.Setup.NewAccount.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Setup_NewAccount
                |> View.map Page

        Main.Pages.Model.SetupKnown pageModel ->
            Page.view (Pages.SetupKnown.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.SetupKnown
                |> View.map Page

        Main.Pages.Model.NotFound_ pageModel ->
            Page.view (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.NotFound_
                |> View.map Page

        Main.Pages.Model.Redirecting_ ->
            View.none

        Main.Pages.Model.Loading_ ->
            Auth.viewCustomPage model.shared (Route.fromUrl () model.url)
                |> View.map never



-- INTERNALS


fromPageEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Main.Pages.Msg.Msg -> Cmd Msg
fromPageEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Page effect)


fromLayoutEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Main.Layouts.Msg.Msg -> Cmd Msg
fromLayoutEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Layout effect)


fromSharedEffect : { model | key : Browser.Navigation.Key, url : Url, shared : Shared.Model } -> Effect Shared.Msg -> Cmd Msg
fromSharedEffect model effect =
    Effect.toCmd
        { key = model.key
        , url = model.url
        , shared = model.shared
        , fromSharedMsg = Shared
        , batch = Batch
        , toCmd = Task.succeed >> Task.perform identity
        }
        (Effect.map Shared effect)



-- URL HOOKS FOR PAGES


toPageUrlHookCmd : Model -> { from : Route (), to : Route () } -> Cmd Msg
toPageUrlHookCmd model routes =
    let
        toCommands messages =
            messages
                |> List.map (Task.succeed >> Task.perform identity)
                |> Cmd.batch
    in
    case model.page of
        Main.Pages.Model.Home_ pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Home_.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Home_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Admin pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Admin.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Admin
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Lists
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Create pageModel ->
            Page.toUrlMessages routes (Pages.Lists.Create.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Lists_Create
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Page.toUrlMessages routes (Pages.Lists.Id_.CreateItem.page model.shared (Route.fromUrl params model.url)) 
                |> List.map Main.Pages.Msg.Lists_Id__CreateItem
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Page.toUrlMessages routes (Pages.Lists.ListId_.page model.shared (Route.fromUrl params model.url)) 
                |> List.map Main.Pages.Msg.Lists_ListId_
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Manual pageModel ->
            Page.toUrlMessages routes (Pages.Manual.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Manual
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Setup pageModel ->
            Page.toUrlMessages routes (Pages.Setup.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Setup
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Setup_Connect pageModel ->
            Page.toUrlMessages routes (Pages.Setup.Connect.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Setup_Connect
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Setup_NewAccount pageModel ->
            Page.toUrlMessages routes (Pages.Setup.NewAccount.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Setup_NewAccount
                |> List.map Page
                |> toCommands

        Main.Pages.Model.SetupKnown pageModel ->
            Page.toUrlMessages routes (Pages.SetupKnown.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.SetupKnown
                |> List.map Page
                |> toCommands

        Main.Pages.Model.NotFound_ pageModel ->
            Page.toUrlMessages routes (Pages.NotFound_.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.NotFound_
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Redirecting_ ->
            Cmd.none

        Main.Pages.Model.Loading_ ->
            Cmd.none


toLayoutUrlHookCmd : Model -> Model -> { from : Route (), to : Route () } -> Cmd Msg
toLayoutUrlHookCmd oldModel model routes =
    let
        toCommands messages =
            if shouldFireUrlChangedEvents then
                messages
                    |> List.map (Task.succeed >> Task.perform identity)
                    |> Cmd.batch

            else
                Cmd.none

        shouldFireUrlChangedEvents =
            hasNavigatedWithinNewLayout
                { from = toLayoutFromPage oldModel
                , to = toLayoutFromPage model
                }

        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout ) of
        _ ->
            Cmd.none


hasNavigatedWithinNewLayout : { from : Maybe (Layouts.Layout msg), to : Maybe (Layouts.Layout msg) } -> Bool
hasNavigatedWithinNewLayout { from, to } =
    let
        isRelated maybePair =
            case maybePair of
                _ ->
                    False
    in
    List.any isRelated
        [ Maybe.map2 Tuple.pair from to
        , Maybe.map2 Tuple.pair to from
        ]


isAuthProtected : Route.Path.Path -> Bool
isAuthProtected routePath =
    case routePath of
        Route.Path.Home_ ->
            True

        Route.Path.Admin ->
            True

        Route.Path.Lists ->
            True

        Route.Path.Lists_Create ->
            False

        Route.Path.Lists_Id__CreateItem _ ->
            False

        Route.Path.Lists_ListId_ _ ->
            False

        Route.Path.Manual ->
            False

        Route.Path.Setup ->
            False

        Route.Path.Setup_Connect ->
            False

        Route.Path.Setup_NewAccount ->
            False

        Route.Path.SetupKnown ->
            False

        Route.Path.NotFound_ ->
            False
