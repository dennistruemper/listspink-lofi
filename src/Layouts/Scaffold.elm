module Layouts.Scaffold exposing (Model, Msg(..), Props, layout)

import Auth
import Bridge
import Components.Caption as Caption
import Components.Toast
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Html.Events
import Layout exposing (Layout)
import Role
import Route exposing (Route)
import Route.Path
import Shared
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)


type alias Props =
    { caption : Maybe String
    }


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init (shared.user |> Maybe.withDefault Bridge.Unknown)
        , update = update
        , view = view shared props.caption
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { user : Auth.User
    }


init : Auth.User -> () -> ( Model, Effect Msg )
init user _ =
    ( { user = user
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = CloseSidebarClicked
    | OpenSidebarClicked
    | NavigationClicked Route.Path.Path
    | ToastRemoveToast Int


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        CloseSidebarClicked ->
            ( model
            , Effect.toggleSidebar False
            )

        OpenSidebarClicked ->
            ( model, Effect.toggleSidebar True )

        NavigationClicked path ->
            ( model, Effect.pushRoutePath path )

        ToastRemoveToast id ->
            ( model, Effect.removeToast id )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Maybe String -> { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view shared caption { toContentMsg, model, content } =
    { title = content.title
    , body =
        [ scaffold shared caption toContentMsg content.body ]
    }


mapToastMsg : (Msg -> contentMsg) -> Components.Toast.Msg -> contentMsg
mapToastMsg toContentMsg toastMsg =
    case toastMsg of
        Components.Toast.RemoveToast id ->
            toContentMsg (ToastRemoveToast id)


scaffold : Shared.Model -> Maybe String -> (Msg -> contentMsg) -> List (Html contentMsg) -> Html contentMsg
scaffold shared caption toContentMsg content =
    let
        mobileMenuHidden =
            case shared.menuOpen of
                True ->
                    "z-20 lg:z-0"

                False ->
                    "hidden"

        blur =
            if shared.menuOpen then
                [ div
                    [ Attr.class "z-20 fixed inset-0 bg-gray-900/80"
                    , Attr.attribute "aria-hidden" "true"
                    , Html.Events.onClick (toContentMsg CloseSidebarClicked)
                    ]
                    []
                ]

            else
                []

        toastView =
            Components.Toast.view shared.toasts (mapToastMsg toContentMsg)
    in
    main_ [ Attr.class " h-screen w-full flex flex-row safe-content h-screen-safe" ]
        (blur
            ++ [ div [ Attr.class (mobileMenuHidden ++ " lg:block absolute top-0 left-0 lg:static h-full bg-fuchsia-300 p-4 flex flex-col content-start") ]
                    [ button
                        [ Attr.type_ "button"
                        , Attr.class "lg:hidden"
                        , Html.Events.onClick (toContentMsg CloseSidebarClicked)
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Close sidebar" ]
                        , svg
                            [ SvgAttr.class "h-6 w-6 text-gray-900"
                            , SvgAttr.fill "none"
                            , SvgAttr.viewBox "0 0 24 24"
                            , SvgAttr.strokeWidth "1.5"
                            , SvgAttr.stroke "currentColor"
                            , Attr.attribute "aria-hidden" "true"
                            ]
                            [ path
                                [ SvgAttr.strokeLinecap "round"
                                , SvgAttr.strokeLinejoin "round"
                                , SvgAttr.d "M6 18L18 6M6 6l12 12"
                                ]
                                []
                            ]
                        ]
                    , menuEntry toContentMsg Route.Path.Home_ "Home"
                    , horizontalDevider
                    , menuEntry toContentMsg Route.Path.Lists "Lists"
                    , div [ Attr.class "grow" ] []
                    , div [ Attr.class "hidden lg:block" ] [ horizontalDevider ]
                    , menuEntryEnabledForRole toContentMsg shared.user Role.Admin Route.Path.Admin_Menu "Admin"
                    , horizontalDevider
                    , menuEntry toContentMsg Route.Path.Account "Account"
                    , horizontalDevider
                    , menuEntry toContentMsg Route.Path.Credits "Credits"
                    , horizontalDevider
                    , menuEntry
                        toContentMsg
                        Route.Path.Settings
                        "Settings"
                    ]
               , div [ Attr.class "w-full h-full flex flex-col" ]
                    [ appBar caption toContentMsg
                    , div [ Attr.class "grow overflow-y-scroll" ] content
                    ]
               , toastView
               ]
        )


menuEntryEnabledForRole : (Msg -> contentMsg) -> Maybe Auth.User -> Role.Role -> Route.Path.Path -> String -> Html contentMsg
menuEntryEnabledForRole toContentMsg user role path caption =
    case user of
        Just Bridge.Unknown ->
            div [] []

        Just (Bridge.UserOnDevice userData) ->
            if userData.roles |> List.member role then
                menuEntry toContentMsg path caption

            else
                div [] []

        Nothing ->
            div [] []


menuEntry : (Msg -> contentMsg) -> Route.Path.Path -> String -> Html contentMsg
menuEntry toContentMsg path caption =
    div
        [ Attr.class "flex flex-row w-full p-2"
        ]
        [ button
            [ Attr.type_ "button"
            , Attr.class "-m-2.5 p-2.5 text-gray-700"
            , Html.Events.onClick (toContentMsg (NavigationClicked path))
            ]
            [ h2
                [ Attr.class "text-lg font-semibold" ]
                [ text caption ]
            ]
        ]


horizontalDevider : Html contentMsg
horizontalDevider =
    div
        [ Attr.class "h-px w-full bg-gray-900/10"
        , Attr.attribute "aria-hidden" "true"
        ]
        []


spacer : Html contentMsg -> Html contentMsg
spacer content =
    div
        [ Attr.class "flex flex-col justify-end h-full"
        ]
        [ content ]


appBar captionInput toContentMsg =
    let
        caption =
            case captionInput of
                Just captionText ->
                    Caption.caption1 captionText |> Caption.view

                Nothing ->
                    div [] []
    in
    header
        [ Attr.class "flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm sm:gap-x-6 sm:px-6 lg:px-8"
        ]
        [ button
            [ Attr.type_ "button"
            , Attr.class "-m-2.5 p-2.5 text-gray-700 lg:hidden"
            , Html.Events.onClick (toContentMsg OpenSidebarClicked)
            ]
            [ span
                [ Attr.class "sr-only"
                ]
                [ text "Open sidebar" ]
            , svg
                [ SvgAttr.class "h-6 w-6"
                , SvgAttr.fill "none"
                , SvgAttr.viewBox "0 0 24 24"
                , SvgAttr.strokeWidth "1.5"
                , SvgAttr.stroke "currentColor"
                , Attr.attribute "aria-hidden" "true"
                ]
                [ path
                    [ SvgAttr.strokeLinecap "round"
                    , SvgAttr.strokeLinejoin "round"
                    , SvgAttr.d "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                    ]
                    []
                ]
            ]
        , {- Separator -}
          div
            [ Attr.class "h-6 w-px bg-gray-900/10 lg:hidden"
            , Attr.attribute "aria-hidden" "true"
            ]
            []
        , caption
        , div
            [ Attr.class "flex flex-1 gap-x-4 self-stretch lg:gap-x-6"
            ]
            [ div
                [ Attr.class "flex items-center justify-end w-full gap-x-4 lg:gap-x-6"
                ]
                [ div
                    []
                    [ button
                        [ Attr.type_ "button"
                        , Attr.class "-m-1.5 flex items-center p-1.5 text-gray-700"
                        , Attr.id "user-menu-button"
                        , Attr.attribute "aria-expanded" "false"
                        , Attr.attribute "aria-haspopup" "true"
                        , Html.Events.onClick (toContentMsg (NavigationClicked Route.Path.Account))
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Open user menu" ]
                        , svg
                            [ SvgAttr.fill "none"
                            , SvgAttr.viewBox "0 0 24 24"
                            , SvgAttr.strokeWidth "1.5"
                            , SvgAttr.stroke "currentColor"
                            , SvgAttr.class "size-6"
                            ]
                            [ path
                                [ SvgAttr.strokeLinecap "round"
                                , SvgAttr.strokeLinejoin "round"
                                , SvgAttr.d "M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]
