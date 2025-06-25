module Event exposing
    ( EventData(..)
    , EventDefinition(..)
    , EventMetadata
    , ItemCreatedData
    , ItemDeletedData
    , ItemStateChangedData
    , ItemUpdatedData
    , ListCreatedData
    , ListSharedWithUserData
    , ListUpdatedData
    , PinkItem
    , PinkList
    , State
    , createItemCreatedEvent
    , createItemDeletedEvent
    , createItemStateChangedEvent
    , createItemUpdatedEvent
    , createListCreatedEvent
    , createListSharedWithUserEvent
    , createListUpdatedEvent
    , getAggregateId
    , getEventId
    , getMetadata
    , getTime
    , getUserId
    , initialState
    , project
    )

import Dict exposing (Dict)
import ItemPriority exposing (ItemPriority)
import Time


type alias EventMetadata =
    { eventId : String
    , aggregateId : String
    , userId : String
    , timestamp : Time.Posix
    }


type EventData
    = ListCreated ListCreatedData
    | ListUpdated ListUpdatedData
    | ListSharedWithUser ListSharedWithUserData
    | ItemCreated ItemCreatedData
    | ItemStateChanged ItemStateChangedData
    | ItemUpdated ItemUpdatedData
    | ItemDeleted ItemDeletedData


type alias ListCreatedData =
    { listId : String
    , name : String
    }


type alias ListUpdatedData =
    { name : String
    }


type alias ListSharedWithUserData =
    { userId : String, listId : String }


type alias ItemUpdatedData =
    { itemId : String, listId : String, name : Maybe String, completed : Maybe (Maybe Time.Posix), itemPriority : Maybe ItemPriority, description : Maybe String }


type alias ItemCreatedData =
    { itemId : String, itemName : String, itemDescription : Maybe String, itemPriority : Maybe ItemPriority }


type alias ItemStateChangedData =
    { itemId : String, newState : Bool }


type alias ItemDeletedData =
    { itemId : String }


type EventDefinition
    = Event EventMetadata EventData


createListCreatedEvent :
    EventMetadata
    -> { listId : String, name : String }
    -> EventDefinition
createListCreatedEvent metadata data =
    Event metadata (ListCreated data)


createListUpdatedEvent :
    EventMetadata
    -> { name : String }
    -> EventDefinition
createListUpdatedEvent metadata data =
    Event metadata (ListUpdated data)


createItemUpdatedEvent :
    EventMetadata
    -> { itemId : String, listId : String, name : Maybe String, completed : Maybe (Maybe Time.Posix), itemPriority : Maybe ItemPriority, description : Maybe String }
    -> EventDefinition
createItemUpdatedEvent metadata data =
    Event metadata (ItemUpdated data)


createItemCreatedEvent :
    EventMetadata
    -> { itemId : String, itemName : String, itemDescription : Maybe String, itemPriority : Maybe ItemPriority }
    -> EventDefinition
createItemCreatedEvent metadata data =
    Event metadata (ItemCreated data)


createItemStateChangedEvent :
    EventMetadata
    -> { itemId : String, newState : Bool }
    -> EventDefinition
createItemStateChangedEvent metadata data =
    Event metadata (ItemStateChanged data)


createListSharedWithUserEvent :
    EventMetadata
    -> { userId : String, listId : String }
    -> EventDefinition
createListSharedWithUserEvent metadata data =
    Event metadata (ListSharedWithUser data)


createItemDeletedEvent :
    EventMetadata
    -> { itemId : String }
    -> EventDefinition
createItemDeletedEvent metadata data =
    Event metadata (ItemDeleted data)


getMetadata : EventDefinition -> EventMetadata
getMetadata event =
    case event of
        Event metadata _ ->
            metadata


getAggregateId : EventDefinition -> String
getAggregateId event =
    case event of
        Event metadata _ ->
            metadata.aggregateId


getEventId : EventDefinition -> String
getEventId event =
    case event of
        Event metadata _ ->
            metadata.eventId


getUserId : EventDefinition -> String
getUserId event =
    case event of
        Event metadata _ ->
            metadata.userId


getTime : EventDefinition -> Time.Posix
getTime event =
    case event of
        Event metadata _ ->
            metadata.timestamp


type alias State =
    { lists : Dict String PinkList
    }


type alias PinkList =
    { name : String
    , listId : String
    , items : Dict String PinkItem
    , createdAt : Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    , users : List String
    }


type alias PinkItem =
    { name : String
    , itemId : String
    , description : Maybe String
    , createdAt : Time.Posix
    , completedAt : Maybe Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
    , priority : ItemPriority
    }


initialState : State
initialState =
    { lists = Dict.empty }


project : List EventDefinition -> State -> State
project events state =
    List.foldl projectEvent state events


projectEvent : EventDefinition -> State -> State
projectEvent event state =
    case event of
        Event metadata data ->
            case data of
                ListCreated listData ->
                    handleListCreated metadata listData state

                ListUpdated listData ->
                    handleListUpdated metadata listData state

                ListSharedWithUser listData ->
                    handleListSharedWithUser listData state

                ItemCreated itemData ->
                    handleItemCreated metadata itemData state

                ItemStateChanged itemData ->
                    handleItemStateChanged metadata itemData state

                ItemUpdated itemData ->
                    handleItemUpdated metadata itemData state

                ItemDeleted itemData ->
                    handleItemDeleted metadata itemData state


handleListCreated : EventMetadata -> ListCreatedData -> State -> State
handleListCreated metadata listData state =
    { state
        | lists =
            Dict.insert listData.listId
                { name = listData.name
                , listId = listData.listId
                , items = Dict.empty
                , createdAt = metadata.timestamp
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = 0
                , users = []
                }
                state.lists
    }


handleListUpdated : EventMetadata -> ListUpdatedData -> State -> State
handleListUpdated metadata listData state =
    updateList metadata.aggregateId
        (\list ->
            { list
                | name = listData.name
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = list.numberOfUpdates + 1
            }
        )
        state


handleListSharedWithUser : ListSharedWithUserData -> State -> State
handleListSharedWithUser listData state =
    updateList listData.listId
        (\list -> { list | users = listData.userId :: list.users })
        state


handleItemCreated : EventMetadata -> ItemCreatedData -> State -> State
handleItemCreated metadata itemData state =
    updateList metadata.aggregateId
        (\list ->
            { list
                | items =
                    Dict.insert itemData.itemId
                        { name = itemData.itemName
                        , itemId = itemData.itemId
                        , description = itemData.itemDescription
                        , createdAt = metadata.timestamp
                        , completedAt = Nothing
                        , lastUpdatedAt = metadata.timestamp
                        , numberOfUpdates = 0
                        , priority = Maybe.withDefault ItemPriority.MediumItemPriority itemData.itemPriority
                        }
                        list.items
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = list.numberOfUpdates + 1
            }
        )
        state


handleItemStateChanged : EventMetadata -> ItemStateChangedData -> State -> State
handleItemStateChanged metadata itemData state =
    updateList metadata.aggregateId
        (\list ->
            { list
                | items = updateItem itemData.itemId (updateItemState metadata itemData) list.items
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = list.numberOfUpdates + 1
            }
        )
        state


handleItemUpdated : EventMetadata -> ItemUpdatedData -> State -> State
handleItemUpdated metadata itemData state =
    updateList metadata.aggregateId
        (\list ->
            { list
                | items = updateItem itemData.itemId (updateItemFields metadata itemData) list.items
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = list.numberOfUpdates + 1
            }
        )
        state


handleItemDeleted : EventMetadata -> ItemDeletedData -> State -> State
handleItemDeleted metadata itemData state =
    updateList metadata.aggregateId
        (\list ->
            { list
                | items = Dict.remove itemData.itemId list.items
                , lastUpdatedAt = metadata.timestamp
                , numberOfUpdates = list.numberOfUpdates + 1
            }
        )
        state



-- Helper functions


updateList : String -> (PinkList -> PinkList) -> State -> State
updateList listId updateFn state =
    { state
        | lists =
            Dict.update listId
                (Maybe.map updateFn)
                state.lists
    }


updateItem : String -> (PinkItem -> PinkItem) -> Dict String PinkItem -> Dict String PinkItem
updateItem itemId updateFn items =
    Dict.update itemId (Maybe.map updateFn) items


updateItemState : EventMetadata -> ItemStateChangedData -> PinkItem -> PinkItem
updateItemState metadata itemData item =
    { item
        | completedAt =
            if itemData.newState then
                Just metadata.timestamp

            else
                Nothing
        , lastUpdatedAt = metadata.timestamp
        , numberOfUpdates = item.numberOfUpdates + 1
    }


updateItemFields : EventMetadata -> ItemUpdatedData -> PinkItem -> PinkItem
updateItemFields metadata itemData item =
    { item
        | name = itemData.name |> Maybe.withDefault item.name
        , completedAt =
            case itemData.completed of
                Just (Just time) ->
                    Just time

                Just Nothing ->
                    Nothing

                Nothing ->
                    item.completedAt
        , lastUpdatedAt = metadata.timestamp
        , numberOfUpdates = item.numberOfUpdates + 1
        , priority = Maybe.withDefault ItemPriority.MediumItemPriority itemData.itemPriority
        , description =
            itemData.description
                |> Maybe.map (\description -> Just description)
                |> Maybe.withDefault item.description
    }
