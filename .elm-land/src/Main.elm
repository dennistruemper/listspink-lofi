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
import Layouts.Scaffold
import Main.Layouts.Model
import Main.Layouts.Msg
import Main.Pages.Model
import Main.Pages.Msg
import Page
import Pages.Home_
import Pages.Account
import Pages.Admin
import Pages.Credits
import Pages.Lists
import Pages.Lists.Create
import Pages.Lists.Edit.ListId_
import Pages.Lists.Id_.CreateItem
import Pages.Lists.ListId_
import Pages.Lists.ListId_.Edit.ItemId_
import Pages.Manual
import Pages.Settings
import Pages.Setup
import Pages.Setup.Connect
import Pages.Setup.NewAccount
import Pages.SetupKnown
import Pages.Share.ListId_
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


initLayout : { key : Browser.Navigation.Key, url : Url, shared : Shared.Model, layout : Maybe Main.Layouts.Model.Model } -> Layouts.Layout Msg -> ( Main.Layouts.Model.Model, Cmd Msg )
initLayout model layout =
    case ( layout, model.layout ) of
        ( Layouts.Scaffold props, Just (Main.Layouts.Model.Scaffold existing) ) ->
            ( Main.Layouts.Model.Scaffold existing
            , Cmd.none
            )

        ( Layouts.Scaffold props, _ ) ->
            let
                route : Route ()
                route =
                    Route.fromUrl () model.url

                scaffoldLayout =
                    Layouts.Scaffold.layout props model.shared route

                ( scaffoldLayoutModel, scaffoldLayoutEffect ) =
                    Layout.init scaffoldLayout ()
            in
            ( Main.Layouts.Model.Scaffold { scaffold = scaffoldLayoutModel }
            , fromLayoutEffect model (Effect.map Main.Layouts.Msg.Scaffold scaffoldLayoutEffect)
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
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Home_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Account ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Account.Model Pages.Account.Msg
                        page =
                            Pages.Account.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Account
                            (Effect.map Main.Pages.Msg.Account >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Account >> Page))
                            |> Maybe.map (initLayout model)
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
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Credits ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Credits.Model Pages.Credits.Msg
                        page =
                            Pages.Credits.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Credits
                            (Effect.map Main.Pages.Msg.Credits >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Credits >> Page))
                            |> Maybe.map (initLayout model)
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
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Lists_Create ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.Create.Model Pages.Lists.Create.Msg
                        page =
                            Pages.Lists.Create.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Lists_Create
                            (Effect.map Main.Pages.Msg.Lists_Create >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Create >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Lists_Edit_ListId_ params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.Edit.ListId_.Model Pages.Lists.Edit.ListId_.Msg
                        page =
                            Pages.Lists.Edit.ListId_.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Lists_Edit_ListId_ params)
                            (Effect.map Main.Pages.Msg.Lists_Edit_ListId_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Edit_ListId_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Lists_Id__CreateItem params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.Id_.CreateItem.Model Pages.Lists.Id_.CreateItem.Msg
                        page =
                            Pages.Lists.Id_.CreateItem.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Lists_Id__CreateItem params)
                            (Effect.map Main.Pages.Msg.Lists_Id__CreateItem >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Id__CreateItem >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Lists_ListId_ params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.ListId_.Model Pages.Lists.ListId_.Msg
                        page =
                            Pages.Lists.ListId_.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Lists_ListId_ params)
                            (Effect.map Main.Pages.Msg.Lists_ListId_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_ListId_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Lists_ListId__Edit_ItemId_ params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Lists.ListId_.Edit.ItemId_.Model Pages.Lists.ListId_.Edit.ItemId_.Msg
                        page =
                            Pages.Lists.ListId_.Edit.ItemId_.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Lists_ListId__Edit_ItemId_ params)
                            (Effect.map Main.Pages.Msg.Lists_ListId__Edit_ItemId_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_ListId__Edit_ItemId_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

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
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.Manual >> Page))
                    |> Maybe.map (initLayout model)
            }

        Route.Path.Settings ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Settings.Model Pages.Settings.Msg
                        page =
                            Pages.Settings.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.Settings
                            (Effect.map Main.Pages.Msg.Settings >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Settings >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

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
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup >> Page))
                    |> Maybe.map (initLayout model)
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
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup_Connect >> Page))
                    |> Maybe.map (initLayout model)
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
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.Setup_NewAccount >> Page))
                    |> Maybe.map (initLayout model)
            }

        Route.Path.SetupKnown ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.SetupKnown.Model Pages.SetupKnown.Msg
                        page =
                            Pages.SetupKnown.page user model.shared (Route.fromUrl () model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            Main.Pages.Model.SetupKnown
                            (Effect.map Main.Pages.Msg.SetupKnown >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.SetupKnown >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

        Route.Path.Share_ListId_ params ->
            runWhenAuthenticatedWithLayout
                model
                (\user ->
                    let
                        page : Page.Page Pages.Share.ListId_.Model Pages.Share.ListId_.Msg
                        page =
                            Pages.Share.ListId_.page user model.shared (Route.fromUrl params model.url)

                        ( pageModel, pageEffect ) =
                            Page.init page ()
                    in
                    { page = 
                        Tuple.mapBoth
                            (Main.Pages.Model.Share_ListId_ params)
                            (Effect.map Main.Pages.Msg.Share_ListId_ >> fromPageEffect model)
                            ( pageModel, pageEffect )
                    , layout = 
                        Page.layout pageModel page
                            |> Maybe.map (Layouts.map (Main.Pages.Msg.Share_ListId_ >> Page))
                            |> Maybe.map (initLayout model)
                    }
                )

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
            , layout = 
                Page.layout pageModel page
                    |> Maybe.map (Layouts.map (Main.Pages.Msg.NotFound_ >> Page))
                    |> Maybe.map (initLayout model)
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

        ( Main.Pages.Msg.Account pageMsg, Main.Pages.Model.Account pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Account
                        (Effect.map Main.Pages.Msg.Account >> fromPageEffect model)
                        (Page.update (Pages.Account.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
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

        ( Main.Pages.Msg.Credits pageMsg, Main.Pages.Model.Credits pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Credits
                        (Effect.map Main.Pages.Msg.Credits >> fromPageEffect model)
                        (Page.update (Pages.Credits.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
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
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Lists_Create
                        (Effect.map Main.Pages.Msg.Lists_Create >> fromPageEffect model)
                        (Page.update (Pages.Lists.Create.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists_Edit_ListId_ pageMsg, Main.Pages.Model.Lists_Edit_ListId_ params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Lists_Edit_ListId_ params)
                        (Effect.map Main.Pages.Msg.Lists_Edit_ListId_ >> fromPageEffect model)
                        (Page.update (Pages.Lists.Edit.ListId_.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists_Id__CreateItem pageMsg, Main.Pages.Model.Lists_Id__CreateItem params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Lists_Id__CreateItem params)
                        (Effect.map Main.Pages.Msg.Lists_Id__CreateItem >> fromPageEffect model)
                        (Page.update (Pages.Lists.Id_.CreateItem.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists_ListId_ pageMsg, Main.Pages.Model.Lists_ListId_ params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Lists_ListId_ params)
                        (Effect.map Main.Pages.Msg.Lists_ListId_ >> fromPageEffect model)
                        (Page.update (Pages.Lists.ListId_.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Lists_ListId__Edit_ItemId_ pageMsg, Main.Pages.Model.Lists_ListId__Edit_ItemId_ params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Lists_ListId__Edit_ItemId_ params)
                        (Effect.map Main.Pages.Msg.Lists_ListId__Edit_ItemId_ >> fromPageEffect model)
                        (Page.update (Pages.Lists.ListId_.Edit.ItemId_.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Manual pageMsg, Main.Pages.Model.Manual pageModel ) ->
            Tuple.mapBoth
                Main.Pages.Model.Manual
                (Effect.map Main.Pages.Msg.Manual >> fromPageEffect model)
                (Page.update (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageMsg pageModel)

        ( Main.Pages.Msg.Settings pageMsg, Main.Pages.Model.Settings pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.Settings
                        (Effect.map Main.Pages.Msg.Settings >> fromPageEffect model)
                        (Page.update (Pages.Settings.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

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
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        Main.Pages.Model.SetupKnown
                        (Effect.map Main.Pages.Msg.SetupKnown >> fromPageEffect model)
                        (Page.update (Pages.SetupKnown.page user model.shared (Route.fromUrl () model.url)) pageMsg pageModel)
                )

        ( Main.Pages.Msg.Share_ListId_ pageMsg, Main.Pages.Model.Share_ListId_ params pageModel ) ->
            runWhenAuthenticated
                model
                (\user ->
                    Tuple.mapBoth
                        (Main.Pages.Model.Share_ListId_ params)
                        (Effect.map Main.Pages.Msg.Share_ListId_ >> fromPageEffect model)
                        (Page.update (Pages.Share.ListId_.page user model.shared (Route.fromUrl params model.url)) pageMsg pageModel)
                )

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
        ( Just (Layouts.Scaffold props), Just (Main.Layouts.Model.Scaffold layoutModel), Main.Layouts.Msg.Scaffold layoutMsg ) ->
            Tuple.mapBoth
                (\newModel -> Just (Main.Layouts.Model.Scaffold { layoutModel | scaffold = newModel }))
                (Effect.map Main.Layouts.Msg.Scaffold >> fromLayoutEffect model)
                (Layout.update (Layouts.Scaffold.layout props model.shared route) layoutMsg layoutModel.scaffold)

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

        Main.Pages.Model.Account pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Account.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Account >> Page))

        Main.Pages.Model.Admin pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Admin.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Admin >> Page))

        Main.Pages.Model.Credits pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Credits.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Credits >> Page))

        Main.Pages.Model.Lists pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Lists.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists >> Page))

        Main.Pages.Model.Lists_Create pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Lists.Create.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Create >> Page))

        Main.Pages.Model.Lists_Edit_ListId_ params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Lists.Edit.ListId_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Edit_ListId_ >> Page))

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Lists.Id_.CreateItem.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_Id__CreateItem >> Page))

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Lists.ListId_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_ListId_ >> Page))

        Main.Pages.Model.Lists_ListId__Edit_ItemId_ params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Lists.ListId_.Edit.ItemId_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Lists_ListId__Edit_ItemId_ >> Page))

        Main.Pages.Model.Manual pageModel ->
            Route.fromUrl () model.url
                |> Pages.Manual.page model.shared
                |> Page.layout pageModel
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Manual >> Page))

        Main.Pages.Model.Settings pageModel ->
            Route.fromUrl () model.url
                |> toAuthProtectedPage model Pages.Settings.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Settings >> Page))

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
                |> toAuthProtectedPage model Pages.SetupKnown.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.SetupKnown >> Page))

        Main.Pages.Model.Share_ListId_ params pageModel ->
            Route.fromUrl params model.url
                |> toAuthProtectedPage model Pages.Share.ListId_.page
                |> Maybe.andThen (Page.layout pageModel)
                |> Maybe.map (Layouts.map (Main.Pages.Msg.Share_ListId_ >> Page))

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

                Main.Pages.Model.Account pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Account.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Account
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

                Main.Pages.Model.Credits pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Credits.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Credits
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
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.Create.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists_Create
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists_Edit_ListId_ params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.Edit.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists_Edit_ListId_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.Id_.CreateItem.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists_Id__CreateItem
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists_ListId_ params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists_ListId_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Lists_ListId__Edit_ItemId_ params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Lists.ListId_.Edit.ItemId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Lists_ListId__Edit_ItemId_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Manual pageModel ->
                    Page.subscriptions (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageModel
                        |> Sub.map Main.Pages.Msg.Manual
                        |> Sub.map Page

                Main.Pages.Model.Settings pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Settings.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Settings
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.SetupKnown.page user model.shared (Route.fromUrl () model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.SetupKnown
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

                Main.Pages.Model.Share_ListId_ params pageModel ->
                    Auth.Action.subscriptions
                        (\user ->
                            Page.subscriptions (Pages.Share.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                                |> Sub.map Main.Pages.Msg.Share_ListId_
                                |> Sub.map Page
                        )
                        (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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
                ( Just (Layouts.Scaffold props), Just (Main.Layouts.Model.Scaffold layoutModel) ) ->
                    Layout.subscriptions (Layouts.Scaffold.layout props model.shared route) layoutModel.scaffold
                        |> Sub.map Main.Layouts.Msg.Scaffold
                        |> Sub.map Layout

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
    let
        route : Route ()
        route =
            Route.fromUrl () model.url
    in
    case ( toLayoutFromPage model, model.layout ) of
        ( Just (Layouts.Scaffold props), Just (Main.Layouts.Model.Scaffold layoutModel) ) ->
            Layout.view
                (Layouts.Scaffold.layout props model.shared route)
                { model = layoutModel.scaffold
                , toContentMsg = Main.Layouts.Msg.Scaffold >> Layout
                , content = viewPage model
                }

        _ ->
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

        Main.Pages.Model.Account pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Account.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Account
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

        Main.Pages.Model.Credits pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Credits.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Credits
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
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.Create.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists_Create
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Edit_ListId_ params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.Edit.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists_Edit_ListId_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.Id_.CreateItem.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists_Id__CreateItem
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists_ListId_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_ListId__Edit_ItemId_ params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Lists.ListId_.Edit.ItemId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Lists_ListId__Edit_ItemId_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Manual pageModel ->
            Page.view (Pages.Manual.page model.shared (Route.fromUrl () model.url)) pageModel
                |> View.map Main.Pages.Msg.Manual
                |> View.map Page

        Main.Pages.Model.Settings pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Settings.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.Settings
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.SetupKnown.page user model.shared (Route.fromUrl () model.url)) pageModel
                        |> View.map Main.Pages.Msg.SetupKnown
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Share_ListId_ params pageModel ->
            Auth.Action.view (View.map never (Auth.viewCustomPage model.shared (Route.fromUrl () model.url)))
                (\user ->
                    Page.view (Pages.Share.ListId_.page user model.shared (Route.fromUrl params model.url)) pageModel
                        |> View.map Main.Pages.Msg.Share_ListId_
                        |> View.map Page
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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

        Main.Pages.Model.Account pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Account.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Account
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

        Main.Pages.Model.Credits pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Credits.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Credits
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
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.Create.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Lists_Create
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Edit_ListId_ params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.Edit.ListId_.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Lists_Edit_ListId_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_Id__CreateItem params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.Id_.CreateItem.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Lists_Id__CreateItem
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_ListId_ params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.ListId_.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Lists_ListId_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Lists_ListId__Edit_ItemId_ params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Lists.ListId_.Edit.ItemId_.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Lists_ListId__Edit_ItemId_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Manual pageModel ->
            Page.toUrlMessages routes (Pages.Manual.page model.shared (Route.fromUrl () model.url)) 
                |> List.map Main.Pages.Msg.Manual
                |> List.map Page
                |> toCommands

        Main.Pages.Model.Settings pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Settings.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.Settings
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.SetupKnown.page user model.shared (Route.fromUrl () model.url)) 
                        |> List.map Main.Pages.Msg.SetupKnown
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

        Main.Pages.Model.Share_ListId_ params pageModel ->
            Auth.Action.command
                (\user ->
                    Page.toUrlMessages routes (Pages.Share.ListId_.page user model.shared (Route.fromUrl params model.url)) 
                        |> List.map Main.Pages.Msg.Share_ListId_
                        |> List.map Page
                        |> toCommands
                )
                (Auth.onPageLoad model.shared (Route.fromUrl () model.url))

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
        ( Just (Layouts.Scaffold props), Just (Main.Layouts.Model.Scaffold layoutModel) ) ->
            Layout.toUrlMessages routes (Layouts.Scaffold.layout props model.shared route)
                |> List.map Main.Layouts.Msg.Scaffold
                |> List.map Layout
                |> toCommands

        _ ->
            Cmd.none


hasNavigatedWithinNewLayout : { from : Maybe (Layouts.Layout msg), to : Maybe (Layouts.Layout msg) } -> Bool
hasNavigatedWithinNewLayout { from, to } =
    let
        isRelated maybePair =
            case maybePair of
                Just ( Layouts.Scaffold _, Layouts.Scaffold _ ) ->
                    True

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

        Route.Path.Account ->
            True

        Route.Path.Admin ->
            True

        Route.Path.Credits ->
            True

        Route.Path.Lists ->
            True

        Route.Path.Lists_Create ->
            True

        Route.Path.Lists_Edit_ListId_ _ ->
            True

        Route.Path.Lists_Id__CreateItem _ ->
            True

        Route.Path.Lists_ListId_ _ ->
            True

        Route.Path.Lists_ListId__Edit_ItemId_ _ ->
            True

        Route.Path.Manual ->
            False

        Route.Path.Settings ->
            True

        Route.Path.Setup ->
            False

        Route.Path.Setup_Connect ->
            False

        Route.Path.Setup_NewAccount ->
            False

        Route.Path.SetupKnown ->
            True

        Route.Path.Share_ListId_ _ ->
            True

        Route.Path.NotFound_ ->
            False
