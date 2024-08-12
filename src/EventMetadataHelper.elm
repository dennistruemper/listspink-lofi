module EventMetadataHelper exposing (createEventMetadata)

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
                    Ok { eventId = nextIds.eventId, aggregateId = getAggregateId nextIds, userId = userOnDeviceData.userId, timestamp = timestamp }
