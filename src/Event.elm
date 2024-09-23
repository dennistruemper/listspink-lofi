module Event exposing
    ( EventData(..)
    , EventDefinition(..)
    , EventMetadata
    , ItemCreatedData
    , ItemStateChangedData
    , ItemUpdatedData
    , ListCreatedData
    , ListUpdatedData
    , PinkItem
    , PinkList
    , State
    , createItemCreatedEvent
    , createItemStateChangedEvent
    , createItemUpdatedEvent
    , createListCreatedEvent
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
    | ItemCreated ItemCreatedData
    | ItemStateChanged ItemStateChangedData
    | ItemUpdated ItemUpdatedData


type alias ListCreatedData =
    { listId : String
    , name : String
    }


type alias ListUpdatedData =
    { name : String
    }


type alias ItemUpdatedData =
    { itemId : String, listId : String, name : Maybe String, completed : Maybe (Maybe Time.Posix) }


type alias ItemCreatedData =
    { itemId : String, itemName : String, itemDescription : Maybe String }


type alias ItemStateChangedData =
    { itemId : String, newState : Bool }


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
    -> { itemId : String, listId : String, name : Maybe String, completed : Maybe (Maybe Time.Posix) }
    -> EventDefinition
createItemUpdatedEvent metadata data =
    Event metadata (ItemUpdated data)


createItemCreatedEvent :
    EventMetadata
    -> { itemId : String, itemName : String, itemDescription : Maybe String }
    -> EventDefinition
createItemCreatedEvent metadata data =
    Event metadata (ItemCreated data)


createItemStateChangedEvent :
    EventMetadata
    -> { itemId : String, newState : Bool }
    -> EventDefinition
createItemStateChangedEvent metadata data =
    Event metadata (ItemStateChanged data)


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
    }


type alias PinkItem =
    { name : String
    , itemId : String
    , description : Maybe String
    , createdAt : Time.Posix
    , completedAt : Maybe Time.Posix
    , lastUpdatedAt : Time.Posix
    , numberOfUpdates : Int
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
                    { state
                        | lists =
                            Dict.insert listData.listId
                                { name = listData.name
                                , listId = listData.listId
                                , items = Dict.empty
                                , createdAt = metadata.timestamp
                                , lastUpdatedAt = metadata.timestamp
                                , numberOfUpdates = 0
                                }
                                state.lists
                    }

                ListUpdated listData ->
                    { state
                        | lists =
                            Dict.update
                                metadata.aggregateId
                                (\maybeList ->
                                    case maybeList of
                                        Just list ->
                                            Just
                                                { list
                                                    | name = listData.name
                                                    , lastUpdatedAt = metadata.timestamp
                                                    , numberOfUpdates = list.numberOfUpdates + 1
                                                }

                                        Nothing ->
                                            Nothing
                                )
                                state.lists
                    }

                ItemCreated itemData ->
                    { state
                        | lists =
                            Dict.update
                                metadata.aggregateId
                                (\maybeList ->
                                    case maybeList of
                                        Just list ->
                                            Just
                                                { list
                                                    | items =
                                                        case Dict.get itemData.itemId list.items of
                                                            Just _ ->
                                                                list.items

                                                            Nothing ->
                                                                Dict.insert itemData.itemId
                                                                    { name = itemData.itemName
                                                                    , itemId = itemData.itemId
                                                                    , description = itemData.itemDescription
                                                                    , createdAt = metadata.timestamp
                                                                    , completedAt = Nothing
                                                                    , lastUpdatedAt = metadata.timestamp
                                                                    , numberOfUpdates = 0
                                                                    }
                                                                    list.items
                                                    , lastUpdatedAt = metadata.timestamp
                                                    , numberOfUpdates = list.numberOfUpdates + 1
                                                }

                                        Nothing ->
                                            Nothing
                                )
                                state.lists
                    }

                ItemStateChanged itemData ->
                    { state
                        | lists =
                            Dict.update
                                metadata.aggregateId
                                (\maybeList ->
                                    case maybeList of
                                        Just list ->
                                            Just
                                                { list
                                                    | items =
                                                        Dict.update
                                                            itemData.itemId
                                                            (\maybeItem ->
                                                                case maybeItem of
                                                                    Just item ->
                                                                        Just
                                                                            { item
                                                                                | completedAt =
                                                                                    if itemData.newState then
                                                                                        Just metadata.timestamp

                                                                                    else
                                                                                        Nothing
                                                                                , lastUpdatedAt = metadata.timestamp
                                                                                , numberOfUpdates = item.numberOfUpdates + 1
                                                                            }

                                                                    Nothing ->
                                                                        Nothing
                                                            )
                                                            list.items
                                                    , lastUpdatedAt = metadata.timestamp
                                                    , numberOfUpdates = list.numberOfUpdates + 1
                                                }

                                        Nothing ->
                                            Nothing
                                )
                                state.lists
                    }

                ItemUpdated itemData ->
                    { state
                        | lists =
                            Dict.update metadata.aggregateId
                                (\maybeList ->
                                    Maybe.map
                                        (\list ->
                                            { list
                                                | items =
                                                    Dict.update itemData.itemId
                                                        (\maybeItem ->
                                                            Maybe.map
                                                                (\item ->
                                                                    let
                                                                        newCompletedAt =
                                                                            case itemData.completed of
                                                                                Just (Just time) ->
                                                                                    Just time

                                                                                Just Nothing ->
                                                                                    Nothing

                                                                                Nothing ->
                                                                                    item.completedAt
                                                                    in
                                                                    { item
                                                                        | name = itemData.name |> Maybe.withDefault item.name
                                                                        , completedAt = newCompletedAt
                                                                        , lastUpdatedAt = metadata.timestamp
                                                                        , numberOfUpdates = item.numberOfUpdates + 1
                                                                    }
                                                                )
                                                                maybeItem
                                                        )
                                                        list.items
                                                , lastUpdatedAt = metadata.timestamp
                                                , numberOfUpdates = list.numberOfUpdates + 1
                                            }
                                        )
                                        maybeList
                                )
                                state.lists
                    }
