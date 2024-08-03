module Sync exposing (BackendSyncModel, FrontendSyncModel, addEventToBackend, addEventToFrontend, addEventsToFrontend, getEventsForAggregateId, getEventsForFrontend, getNewEventsForUser, initBackend, initFrontend)

import Array exposing (Array)
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import Lamdera exposing (SessionId)
import SortedEventList
import Subscriptions
import Time
import UserManagement


type alias BackendSyncModel =
    { aggregates :
        Dict
            String
            { events :
                Array
                    { event : EventDefinition
                    , serverTime : Time.Posix
                    }
            }
    }


type alias FrontendSyncModel =
    { events : SortedEventList.Model
    , lastSyncServerTime : Time.Posix
    }


initBackend : BackendSyncModel
initBackend =
    { aggregates = Dict.empty
    }


initFrontend : FrontendSyncModel
initFrontend =
    { events = SortedEventList.init, lastSyncServerTime = Time.millisToPosix 0 }


addEventToBackend : EventDefinition -> Time.Posix -> Subscriptions.Model -> UserManagement.Model -> BackendSyncModel -> { newBackendModel : BackendSyncModel, subscribedSessions : List { sessionId : SessionId } }
addEventToBackend event serverTime subscriptions userManagement backendModel =
    let
        aggregateId =
            Event.getAggregateId event

        newBackendModel : BackendSyncModel
        newBackendModel =
            { backendModel
                | aggregates =
                    Dict.update
                        aggregateId
                        (\maybeAggregate ->
                            case maybeAggregate of
                                Just eventsForAggregate ->
                                    if
                                        Array.filter
                                            (\e -> Event.getEventId e.event == Event.getEventId event)
                                            eventsForAggregate.events
                                            |> (\result -> Array.length result > 0)
                                    then
                                        Just eventsForAggregate

                                    else
                                        Just
                                            { eventsForAggregate
                                                | events =
                                                    Array.push
                                                        { event = event
                                                        , serverTime = serverTime
                                                        }
                                                        eventsForAggregate.events
                                            }

                                Nothing ->
                                    Just
                                        { events =
                                            Array.fromList
                                                [ { event = event
                                                  , serverTime = serverTime
                                                  }
                                                ]
                                        }
                        )
                        backendModel.aggregates
            }

        subscribedSessions : List { sessionId : SessionId }
        subscribedSessions =
            Subscriptions.getSubscriptionsByAggregateId subscriptions (Event.getAggregateId event)
                |> List.map .userId
                |> List.concatMap (\userId -> UserManagement.getAllSessionsForUser userId userManagement)
                |> List.map (\sessionId -> { sessionId = sessionId })
    in
    { newBackendModel = newBackendModel
    , subscribedSessions = subscribedSessions
    }


getEventsForAggregateId : String -> BackendSyncModel -> List { event : EventDefinition, serverTime : Time.Posix }
getEventsForAggregateId aggregateId backendModel =
    case Dict.get aggregateId backendModel.aggregates of
        Just aggregate ->
            aggregate.events |> Array.toList

        Nothing ->
            []


getNewEventsForUser : SessionId -> Time.Posix -> Subscriptions.Model -> UserManagement.Model -> BackendSyncModel -> List EventDefinition
getNewEventsForUser sessionId lastSyncServerTime subscriptions userManagement backendModel =
    UserManagement.getUserForSession sessionId userManagement
        |> Maybe.map .userId
        |> Maybe.map (\userId -> Subscriptions.getSubscriptionsByUserId subscriptions userId)
        |> Maybe.map (\subs -> List.map .aggregateId subs)
        |> Maybe.map (\aggregateIds -> List.concatMap (\aggregateId -> getEventsForAggregateId aggregateId backendModel) aggregateIds)
        |> Maybe.map (\eventData -> List.filter (\event -> Time.posixToMillis event.serverTime >= Time.posixToMillis lastSyncServerTime) eventData)
        |> Maybe.map (\eventData -> List.map .event eventData)
        |> Maybe.withDefault []


getEventsForFrontend : FrontendSyncModel -> List EventDefinition
getEventsForFrontend frontendModel =
    SortedEventList.getEvents frontendModel.events


updateLastServerSyncTime : Time.Posix -> FrontendSyncModel -> FrontendSyncModel
updateLastServerSyncTime lastSyncServerTime frontendModel =
    { frontendModel | lastSyncServerTime = lastSyncServerTime }


addEventToFrontend : EventDefinition -> FrontendSyncModel -> FrontendSyncModel
addEventToFrontend event frontendModel =
    { frontendModel
        | events = SortedEventList.addEvent event frontendModel.events
    }


addEventsToFrontend : List EventDefinition -> Time.Posix -> FrontendSyncModel -> FrontendSyncModel
addEventsToFrontend events serverTime frontendModel =
    -- TODO ensure ordered by time
    List.foldl
        (\event model -> addEventToFrontend event model)
        frontendModel
        events
        |> updateLastServerSyncTime serverTime
