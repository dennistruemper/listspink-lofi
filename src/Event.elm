module Event exposing
    ( EventData(..)
    , EventDefinition(..)
    , EventMetadata
    , ListCreatedData
    , ListUpdatedData
    , State
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


type alias ListCreatedData =
    { listId : String
    , name : String
    }


type alias ListUpdatedData =
    { name : String
    }


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
                    { state | lists = Dict.insert listData.listId { name = listData.name, listId = listData.listId } state.lists }

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
