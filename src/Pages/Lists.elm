module Pages.Lists exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Center as Center
import Components.Column as Column
import Components.Row as Row
import Dict
import Effect exposing (Effect)
import Event exposing (EventDefinition)
import Format
import Html
import Html.Attributes
import Html.Events
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import SortedEventList
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import Sync
import Time
import View exposing (View)


title =
    "Your Lists"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init
        , update = update shared
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
    , Effect.none
    )



-- UPDATE


type Msg
    = CreateDummyList
    | CreatNewListClicked
    | ImportSharedListClicked


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        CreateDummyList ->
            case shared.nextIds of
                Nothing ->
                    -- TODO
                    ( model, Effect.none )

                Just nextIds ->
                    let
                        event : Maybe EventDefinition
                        event =
                            shared.user
                                |> Maybe.map
                                    (\user ->
                                        case user of
                                            Bridge.Unknown ->
                                                Nothing

                                            Bridge.UserOnDevice userOnDeviceData ->
                                                Just userOnDeviceData.userId
                                    )
                                |> Maybe.map
                                    (\maybeUserId ->
                                        case maybeUserId of
                                            Nothing ->
                                                Nothing

                                            Just userId ->
                                                Just <|
                                                    Event.createListCreatedEvent
                                                        { eventId = nextIds.eventId, aggregateId = nextIds.listId, userId = userId, timestamp = Time.millisToPosix 0 }
                                                        { listId = nextIds.listId, name = "Dummy List" ++ (SortedEventList.length shared.syncModel.events |> String.fromInt) }
                                    )
                                |> Maybe.withDefault Nothing

                        effect =
                            case event of
                                Nothing ->
                                    Effect.none

                                Just evt ->
                                    Effect.addEvent evt
                    in
                    ( model
                    , Effect.batch [ Effect.generateIds, effect ]
                    )

        ImportSharedListClicked ->
            ( model
            , Effect.pushRoutePath Route.Path.List_ImportShared
            )

        CreatNewListClicked ->
            ( model
            , Effect.pushRoutePath Route.Path.Lists_Create
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
        [ AppBar.appBar
            |> AppBar.withContent
                [ Column.column
                    [ viewLists shared

                    -- buttom action bar
                    ]
                    |> Column.view
                ]
            |> AppBar.withActions
                [ Button.button "Import Shared List" ImportSharedListClicked |> Button.view
                , Button.button "Create New List" CreatNewListClicked |> Button.view
                ]
            |> AppBar.view
        ]
    }


viewLists : Shared.Model -> Html.Html Msg
viewLists shared =
    case Dict.values shared.state.lists of
        [] ->
            Html.text "No lists jet"

        lists ->
            Html.div [ Html.Attributes.class "w-full lg:max-w-xl" ]
                [ Html.ul [ Html.Attributes.class "" ]
                    (lists
                        |> List.sortBy (\list -> Time.posixToMillis list.createdAt)
                        |> List.map
                            (\list ->
                                viewList list
                            )
                    )
                ]


viewList : Event.PinkList -> Html.Html Msg
viewList list =
    Html.li
        [ Html.Attributes.class "flex justify-between w-full gap-x-6 px-2 lg:px-4 py-5 hover:bg-gray-50 sm:px-6"
        ]
        [ Html.div
            [ Html.Attributes.class "flex w-full gap-x-4"
            ]
            [ Html.a
                [ Html.Attributes.class "flex items-center"
                , Html.Attributes.href (Route.Path.Lists_Edit_ListId_ { listId = list.listId } |> Route.Path.toString)
                ]
                [ svg
                    [ SvgAttr.fill "none"
                    , SvgAttr.viewBox "0 0 24 24"
                    , SvgAttr.strokeWidth "1.5"
                    , SvgAttr.stroke "currentColor"
                    , SvgAttr.class "size-6"
                    ]
                    [ path
                        [ SvgAttr.strokeLinecap "round"
                        , SvgAttr.strokeLinejoin "round"
                        , SvgAttr.d "M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.325.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.431l-1.003.827c-.293.241-.438.613-.43.992a7.723 7.723 0 0 1 0 .255c-.008.378.137.75.43.991l1.004.827c.424.35.534.955.26 1.43l-1.298 2.247a1.125 1.125 0 0 1-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.47 6.47 0 0 1-.22.128c-.331.183-.581.495-.644.869l-.213 1.281c-.09.543-.56.94-1.11.94h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 0 1-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 0 1-1.369-.49l-1.297-2.247a1.125 1.125 0 0 1 .26-1.431l1.004-.827c.292-.24.437-.613.43-.991a6.932 6.932 0 0 1 0-.255c.007-.38-.138-.751-.43-.992l-1.004-.827a1.125 1.125 0 0 1-.26-1.43l1.297-2.247a1.125 1.125 0 0 1 1.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.086.22-.128.332-.183.582-.495.644-.869l.214-1.28Z"
                        ]
                        []
                    , path
                        [ SvgAttr.strokeLinecap "round"
                        , SvgAttr.strokeLinejoin "round"
                        , SvgAttr.d "M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
                        ]
                        []
                    ]
                ]
            , Html.a
                [ Html.Attributes.class "min-w-0 flex-auto"
                , Html.Attributes.href (Route.Path.Lists_ListId_ { listId = list.listId } |> Route.Path.toString)
                ]
                [ Html.p
                    [ Html.Attributes.class "text-sm font-semibold leading-6 text-gray-900"
                    ]
                    [ Html.div
                        []
                        [ Html.span [] []
                        , Html.text list.name
                        ]
                    ]
                , Html.p
                    [ Html.Attributes.class "mt-1 flex text-xs leading-5 text-gray-500"
                    ]
                    [ Html.div
                        [ Html.Attributes.class "relative truncate"
                        ]
                        [ (\time -> Format.time time)
                            list.createdAt
                            |> Html.text
                        ]
                    ]
                ]
            , Html.a
                [ Html.Attributes.class "flex items-center "
                , Html.Attributes.href (Route.Path.Lists_ListId_ { listId = list.listId } |> Route.Path.toString)
                ]
                [ svg
                    [ SvgAttr.class "h-5 w-5 flex-none text-gray-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Html.Attributes.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            ]
        ]
