module Pages.Lists.ListId_ exposing (Model, Msg(..), page)

import Auth
import Bridge
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
import Lamdera
import Layouts
import NetworkStatus
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Set exposing (Set)
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
    , currentTime : Time.Posix
    , showDoneAfter : Int
    , expandedDescriptions : Set String
    }


showDoneAfter2h : Int
showDoneAfter2h =
    1000 * 60 * 60 * 2


showDoneAfterForever : Int
showDoneAfterForever =
    1000 * 60 * 60 * 24 * 365 * 100


init : String -> Shared.Model -> () -> ( Model, Effect Msg )
init listId shared () =
    let
        reloadEffect =
            if shared.networkStatus == NetworkStatus.NetworkOnline then
                Effect.sendCmd <| Lamdera.sendToBackend (Bridge.ReloadAllForAggregate { aggregateId = listId })

            else
                Effect.none
    in
    ( { listId = listId
      , listName =
            shared.state.lists
                |> Dict.values
                |> List.filter (\l -> l.listId == listId)
                |> List.head
                |> Maybe.map .name
      , currentTime = Time.millisToPosix 0
      , showDoneAfter = showDoneAfter2h
      , expandedDescriptions = Set.empty
      }
    , Effect.batch
        [ Effect.getTime GotCurrentTime
        , reloadEffect
        ]
    )



-- UPDATE


type Msg
    = ItemCheckedToggled String Bool
    | GotTimeForItemCheckedToggled String Bool Time.Posix
    | AddItemClicked
    | GotCurrentTime Time.Posix
    | ToggleArchiveClicked
    | ToggleDescription String


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ItemCheckedToggled itemId checked ->
            ( model, Effect.getTime (GotTimeForItemCheckedToggled itemId checked) )

        GotCurrentTime timestamp ->
            ( { model | currentTime = timestamp }, Effect.none )

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

        ToggleArchiveClicked ->
            ( { model
                | showDoneAfter =
                    if model.showDoneAfter == showDoneAfterForever then
                        showDoneAfter2h

                    else
                        showDoneAfterForever
              }
            , Effect.none
            )

        ToggleDescription itemId ->
            ( { model
                | expandedDescriptions =
                    if Set.member itemId model.expandedDescriptions then
                        Set.remove itemId model.expandedDescriptions

                    else
                        Set.insert itemId model.expandedDescriptions
              }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 60000 GotCurrentTime



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
                let
                    toggleArchiveButtonCaption =
                        if model.showDoneAfter == showDoneAfterForever then
                            "Hide Archived"

                        else
                            "Show Archived"
                in
                AppBar.appBar
                    |> AppBar.withContent
                        (list.items
                            |> Dict.values
                            |> withoutItemsDoneForMoreThanOneHour model.currentTime model.showDoneAfter
                            |> toPriorityBuckets
                            |> viewPriorityBuckets model model.listId
                        )
                    |> AppBar.withActions
                        [ Button.button toggleArchiveButtonCaption ToggleArchiveClicked |> Button.view
                        , Button.button "Add Item" AddItemClicked |> Button.view
                        ]
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


viewPriorityBuckets : Model -> String -> Dict String (List Event.PinkItem) -> List (Html.Html Msg)
viewPriorityBuckets model listId buckets =
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
                                            |> List.map (\item -> viewItem listId model.expandedDescriptions item)
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


viewItem : String -> Set String -> Event.PinkItem -> Html.Html Msg
viewItem listId expandedDescriptions item =
    let
        checked =
            case item.completedAt of
                Just _ ->
                    True

                Nothing ->
                    False

        itemClasses =
            if checked then
                "text-gray-500 line-through"

            else
                "text-gray-900"

        isExpandedValue =
            Set.member item.itemId expandedDescriptions

        description =
            Maybe.withDefault "" item.description

        truncatedDescription =
            if not isExpandedValue && String.length description > 100 then
                String.left 100 description ++ "..."

            else
                description

        descriptionView descriptionInput isExpanded =
            if String.length descriptionInput > 0 then
                Html.div
                    [ Html.Attributes.class "mt-1 group cursor-pointer"
                    , Html.Events.onClick (ToggleDescription item.itemId)
                    ]
                    [ Html.div
                        [ Html.Attributes.class "flex items-center text-xs text-gray-400 hover:text-gray-600"
                        ]
                        [ Html.span
                            [ Html.Attributes.class "mr-1" ]
                            [ Html.text "📝" ]
                        , Html.span
                            [ Html.Attributes.class "text-[10px] group-hover:text-gray-600" ]
                            [ Html.text
                                (if isExpanded then
                                    "↑ Show less"

                                 else
                                    "↓ Show more"
                                )
                            ]
                        ]
                    , Html.div
                        [ Html.Attributes.class "text-gray-600 italic transition-all duration-200"
                        , Html.Attributes.style "max-height"
                            (if isExpanded then
                                "200px"

                             else
                                "2.5em"
                            )
                        , Html.Attributes.style "overflow" "hidden"
                        ]
                        [ Html.text truncatedDescription ]
                    ]

            else
                Html.text ""
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
                [ Html.div
                    [ Html.Attributes.class ("text-sm font-semibold leading-6 " ++ itemClasses)
                    ]
                    [ Html.text item.name ]
                , Html.div
                    [ Html.Attributes.class "mt-1 text-xs leading-5 text-gray-500"
                    ]
                    [ descriptionView (Maybe.withDefault "" item.description) isExpandedValue
                    , Html.div
                        [ Html.Attributes.class "flex gap-3 mt-1 text-gray-400"
                        ]
                        [ Html.span [] [ Html.text ("Created " ++ Format.time item.createdAt) ]
                        , case item.completedAt of
                            Just completedTime ->
                                Html.span [] [ Html.text ("• Completed " ++ Format.time completedTime) ]

                            Nothing ->
                                Html.text ""
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


withoutItemsDoneForMoreThanOneHour : Time.Posix -> Int -> List Event.PinkItem -> List Event.PinkItem
withoutItemsDoneForMoreThanOneHour currentTime showDoneAfter items =
    items
        |> List.filter
            (\item ->
                case item.completedAt of
                    Just completedAt ->
                        (Time.posixToMillis (item.completedAt |> Maybe.withDefault currentTime) + showDoneAfter) - Time.posixToMillis currentTime > 0

                    Nothing ->
                        True
            )


sortByPriority : List Event.PinkItem -> List Event.PinkItem
sortByPriority items =
    List.sortWith (\a b -> ItemPriority.compare_ a.priority b.priority) items
