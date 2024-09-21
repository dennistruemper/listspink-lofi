module Pages.Lists exposing (Model, Msg, page)

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
                [ Button.button "Create New List" CreatNewListClicked |> Button.view
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
        [ Html.Attributes.class "flex justify-between w-full gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6"
        ]
        [ Html.div
            [ Html.Attributes.class "flex w-full gap-x-4"
            ]
            [ Html.input
                [ Html.Attributes.class "h-8 w-8 flex-none rounded-full bg-gray-50 text-fuchsia-500 focus:ring-2 focus:ring-offset-2 focus:ring-fuchsia-500"
                , Html.Attributes.type_ "checkbox"
                ]
                []
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
                [ Html.Attributes.class "flex items-center p-4"
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
