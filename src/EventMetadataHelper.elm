module EventMetadataHelper exposing (createEventMetadata, createEventMetadataWithUserId)

import Bridge
import Event
import Shared.Model
import Time


createEventMetadata : Maybe Shared.Model.NextIds -> (Shared.Model.NextIds -> String) -> Maybe Bridge.User -> Time.Posix -> Result String Event.EventMetadata
createEventMetadata maybeNextIds getAggregateId maybeUser timestamp =
    case maybeNextIds of
        Nothing ->
            Err "No nextIds"

        Just nextIds ->
            case maybeUser of
                Nothing ->
                    Err "No user"

                Just Bridge.Unknown ->
                    Err "Unknown user"

                Just (Bridge.UserOnDevice userOnDeviceData) ->
                    createEventMetadataWithUserId maybeNextIds getAggregateId userOnDeviceData.userId timestamp


createEventMetadataWithUserId : Maybe Shared.Model.NextIds -> (Shared.Model.NextIds -> String) -> String -> Time.Posix -> Result String Event.EventMetadata
createEventMetadataWithUserId maybeNextIds getAggregateId userId timestamp =
    case maybeNextIds of
        Nothing ->
            Err "No nextIds"

        Just nextIds ->
            Ok { eventId = nextIds.eventId, aggregateId = getAggregateId nextIds, userId = userId, timestamp = timestamp }
