module EventTestHelper exposing (createEvent, withTime)

import Event exposing (EventDefinition)
import Time


createEvent : String -> String -> EventDefinition
createEvent eventId aggregateId =
    Event.createListCreatedEvent
        { eventId = eventId
        , aggregateId = aggregateId
        , userId = "dummy"
        , timestamp = Time.millisToPosix 0
        }
        { listId = aggregateId, name = "dummy" }


withTime : Time.Posix -> EventDefinition -> EventDefinition
withTime time event =
    case event of
        Event.Event metadata data ->
            Event.Event { metadata | timestamp = time } data
