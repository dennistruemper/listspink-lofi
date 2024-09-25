module Pages.Lists.ListId_ exposing (Model, Msg, page)

import Auth
import Components.AppBar as AppBar
import Components.Button as Button
import Dict exposing (Dict)
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Format
import Html
import Html.Attributes
import Html.Events
import ItemPriority
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import Time
import View exposing (View)


title =
    "Items"


page : Auth.User -> Shared.Model -> Route { listId : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init route.params.listId shared
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
    { listId : String
    , listName : Maybe String
    }


init : String -> Shared.Model -> () -> ( Model, Effect Msg )
init listId shared () =
    ( { listId = listId
      , listName =
            shared.state.lists
                |> Dict.values
                |> List.filter (\l -> l.listId == listId)
                |> List.head
                |> Maybe.map .name
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ItemCheckedToggled String Bool
    | GotTimeForItemCheckedToggled String Bool Time.Posix
    | AddItemClicked


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ItemCheckedToggled itemId checked ->
            ( model, Effect.getTime (GotTimeForItemCheckedToggled itemId checked) )

        GotTimeForItemCheckedToggled itemId checked timestamp ->
            let
                eventResult : Result String Event.EventMetadata
                eventResult =
                    case
                        EventMetadataHelper.createEventMetadata
                            shared.nextIds
                            (\_ -> model.listId)
                            shared.user
                            timestamp
                    of
                        Ok eventMetadata ->
                            Ok eventMetadata

                        Err error ->
                            Err error
            in
            case eventResult of
                Ok eventMetadata ->
                    ( model, Effect.addEvent <| Event.createItemStateChangedEvent eventMetadata { itemId = itemId, newState = checked } )

                Err error ->
                    --TODO
                    ( model, Effect.none )

        AddItemClicked ->
            ( model, Effect.pushRoutePath (Route.Path.Lists_Id__CreateItem { id = model.listId }) )



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
    { title = title
    , body =
        [ case maybeList of
            Just list ->
                AppBar.appBar
                    |> AppBar.withContent
                        (list.items |> Dict.values |> toPriorityBuckets |> viewPriorityBuckets model.listId)
                    |> AppBar.withActions
                        [ Button.button "Add Item" AddItemClicked |> Button.view ]
                    |> AppBar.view

            Nothing ->
                Html.text "List not found"
        ]
    }


toPriorityBuckets : List Event.PinkItem -> Dict String (List Event.PinkItem)
toPriorityBuckets items =
    items
        |> List.foldl
            (\item buckets ->
                Dict.update
                    (ItemPriority.itemPriorityToString item.priority)
                    (\maybeItems ->
                        case maybeItems of
                            Just i ->
                                Just (item :: i)

                            Nothing ->
                                Just [ item ]
                    )
                    buckets
            )
            Dict.empty


viewPriorityBuckets : String -> Dict String (List Event.PinkItem) -> List (Html.Html Msg)
viewPriorityBuckets listId buckets =
    if Dict.isEmpty buckets then
        [ Html.text "No items jet" ]

    else
        ItemPriority.all
            |> List.reverse
            |> List.map
                (\priority ->
                    case Dict.get (ItemPriority.itemPriorityToString priority) buckets of
                        Just items ->
                            Just
                                (([ viewStickyHeader (ItemPriority.itemPriorityToString priority) ]
                                    ++ (items
                                            |> List.map (\item -> viewItem listId item)
                                       )
                                 )
                                    |> Html.div []
                                )

                        Nothing ->
                            Nothing
                )
            |> List.filterMap identity


viewStickyHeader : String -> Html.Html msg
viewStickyHeader caption =
    Html.div
        [ Html.Attributes.class "sticky top-0 z-10 border-y border-b-gray-200 border-t-gray-100 bg-gray-50 px-3 py-1.5 text-xs font-semibold text-gray-900"
        ]
        [ Html.h3 []
            [ Html.text (caption ++ " Priority") ]
        ]


viewItem : String -> Event.PinkItem -> Html.Html Msg
viewItem listId item =
    let
        checked =
            case item.completedAt of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    Html.li
        [ Html.Attributes.class "flex justify-between w-full gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6"
        ]
        [ Html.div
            [ Html.Attributes.class "flex w-full items-center gap-x-4"
            ]
            [ Html.input
                [ Html.Attributes.class "h-8 w-8 flex-none rounded-full bg-gray-50 text-fuchsia-500 focus:ring-2 focus:ring-offset-2 focus:ring-fuchsia-500"
                , Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked checked
                , Html.Events.onCheck (ItemCheckedToggled item.itemId)
                ]
                []
            , Html.div
                [ Html.Attributes.class "min-w-0 flex-auto"
                ]
                [ Html.p
                    [ Html.Attributes.class "text-sm font-semibold leading-6 text-gray-900"
                    ]
                    [ Html.div
                        []
                        [ Html.span [] []
                        , Html.text item.name
                        ]
                    ]
                , Html.p
                    [ Html.Attributes.class "mt-1 flex text-xs leading-5 text-gray-500"
                    ]
                    [ Html.div
                        [ Html.Attributes.class "relative truncate"
                        ]
                        [ (\time -> Format.time time)
                            item.createdAt
                            |> Html.text
                        ]
                    ]
                ]
            , Html.a
                [ Html.Attributes.class "flex items-center"
                , Html.Attributes.href (Route.Path.Lists_ListId__Edit_ItemId_ { listId = listId, itemId = item.itemId } |> Route.Path.toString)
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
            ]
        ]


posixCompare : Time.Posix -> Time.Posix -> Order
posixCompare a b =
    compare (Time.posixToMillis a) (Time.posixToMillis b)


sortByTimestamp : List Event.PinkItem -> List Event.PinkItem
sortByTimestamp items =
    List.sortBy
        (\a ->
            (a.createdAt |> Time.posixToMillis) * -1
        )
        items


sortByPriority : List Event.PinkItem -> List Event.PinkItem
sortByPriority items =
    List.sortWith (\a b -> ItemPriority.compare_ a.priority b.priority) items
