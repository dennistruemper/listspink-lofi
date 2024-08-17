module Event exposing
    ( EventData(..)
    , EventDefinition(..)
    , EventMetadata
    , ItemCreatedData
    , ListCreatedData
    , ListUpdatedData
    , PinkItem
    , PinkList
    , State
    , createItemCreatedEvent
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


type alias ListCreatedData =
    { listId : String
    , name : String
    }


type alias ListUpdatedData =
    { name : String
    }


type alias ItemCreatedData =
    { itemId : String, itemName : String, itemDescription : Maybe String }


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


createItemCreatedEvent :
    EventMetadata
    -> { itemId : String, itemName : String, itemDescription : Maybe String }
    -> EventDefinition
createItemCreatedEvent metadata data =
    Event metadata (ItemCreated data)


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
    }


type alias PinkItem =
    { name : String
    , itemId : String
    , description : Maybe String
    , createdAt : Time.Posix
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
                                { name = listData.name, listId = listData.listId, items = Dict.empty, createdAt = metadata.timestamp }
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
                                            Just { list | name = listData.name }

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
                                                                    }
                                                                    list.items
                                                }

                                        Nothing ->
                                            Nothing
                                )
                                state.lists
                    }
