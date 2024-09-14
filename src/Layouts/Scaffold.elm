module Layouts.Scaffold exposing (Model, Msg, Props, layout)

import Auth
import Bridge
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Html.Events
import Layout exposing (Layout)
import Route exposing (Route)
import Route.Path
import Shared
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init (shared.user |> Maybe.withDefault Bridge.Unknown)
        , update = update
        , view = view shared
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view shared { toContentMsg, model, content } =
    { title = content.title
    , body =
        [ scaffold shared toContentMsg content.body
        ]
    }


scaffold : Shared.Model -> (Msg -> contentMsg) -> List (Html contentMsg) -> Html contentMsg
scaffold shared toContentMsg content =
    let
        mobileMenuHidden =
            case shared.menuOpen of
                True ->
                    ""

                False ->
                    "hidden"

        blur =
            if shared.menuOpen then
                [ div
                    [ Attr.class "fixed inset-0 bg-gray-900/80"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    []
                ]

            else
                []
    in
    div [ Attr.class " h-screen w-full flex flex-row" ]
        (blur
            ++ [ div [ Attr.class (mobileMenuHidden ++ " lg:block absolute top-0 left-0 lg:static h-full bg-fuchsia-300 z-50 p-4 flex flex-col content-start") ]
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
                    , menuEntry toContentMsg Route.Path.Account "Account"
                    , horizontalDevider
                    , menuEntry
                        toContentMsg
                        Route.Path.Settings
                        "Settings"
                    ]
               , div [ Attr.class "w-full" ]
                    [ appBar toContentMsg
                    , div [] content
                    ]
               ]
        )


menuEntry : (Msg -> contentMsg) -> Route.Path.Path -> String -> Html contentMsg
menuEntry toContentMsg path caption =
    div
        [ Attr.class "flex flex-row w-full"
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


appBar toContentMsg =
    div
        [ Attr.class "sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm sm:gap-x-6 sm:px-6 lg:px-8"
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
