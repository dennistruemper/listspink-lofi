module FrontendSyncModelSerializer exposing
    ( deserializeEvent
    , deserializeFrontendSyncModel
    , deserializeFrontendSyncModelMessageFromJs
    , serializeEvent
    , serializeFrontendSyncModel
    )

import Array exposing (Array)
import Event exposing (EventDefinition)
import Json.Decode
import Json.Encode
import Serialize as S
import Set exposing (Set)
import SortedEventList
import Sync exposing (FrontendSyncModel)
import Time


type alias FrontendSyncModelV1 =
    { events : Array EventDefinition
    , lastSyncServerTime : Time.Posix
    , unsyncedEventIds : Set String
    }


type FrontendSyncModelVersion
    = V1 FrontendSyncModelV1


serializeFrontendSyncModel : FrontendSyncModel -> String
serializeFrontendSyncModel model =
    S.encodeToString frontendSyncModelCodec model


deserializeFrontendSyncModel : String -> Result (S.Error e) FrontendSyncModel
deserializeFrontendSyncModel serializedModel =
    S.decodeFromString frontendSyncModelCodec serializedModel


deserializeFrontendSyncModelMessageFromJs : Json.Decode.Decoder FrontendSyncModel
deserializeFrontendSyncModelMessageFromJs =
    S.getJsonDecoder never frontendSyncModelCodec


frontendSyncModelCodec : S.Codec e FrontendSyncModel
frontendSyncModelCodec =
    S.record FrontendSyncModel
        |> S.field .events eventListCodec
        |> S.field .lastSyncServerTime timeCodec
        |> S.field .unsyncedEventIds (S.set S.string)
        |> S.finishRecord


timeCodec : S.Codec e Time.Posix
timeCodec =
    S.int |> S.map Time.millisToPosix Time.posixToMillis


eventMetadataCodec : S.Codec e Event.EventMetadata
eventMetadataCodec =
    S.record Event.EventMetadata
        |> S.field .eventId S.string
        |> S.field .aggregateId S.string
        |> S.field .userId S.string
        |> S.field .timestamp timeCodec
        |> S.finishRecord


listCreatedCodec =
    S.record Event.ListCreatedData
        |> S.field .listId S.string
        |> S.field .name S.string
        |> S.finishRecord


listUpdatedCodec =
    S.record Event.ListUpdatedData
        |> S.field .name S.string
        |> S.finishRecord


itemCreatedCodec =
    S.record Event.ItemCreatedData
        |> S.field .itemId S.string
        |> S.field .itemName S.string
        |> S.field .itemDescription (S.maybe S.string)
        |> S.finishRecord


eventDataCodec : S.Codec e Event.EventData
eventDataCodec =
    S.customType
        (\listCreatedEncoder listUpdatedEncoder itemCreatedEncoder value ->
            case value of
                Event.ListCreated listCreatedData ->
                    listCreatedEncoder listCreatedData

                Event.ListUpdated listUpdatedData ->
                    listUpdatedEncoder listUpdatedData

                Event.ItemCreated itemCreatedData ->
                    itemCreatedEncoder itemCreatedData
        )
        |> S.variant1 Event.ListCreated listCreatedCodec
        |> S.variant1 Event.ListUpdated listUpdatedCodec
        |> S.variant1 Event.ItemCreated itemCreatedCodec
        |> S.finishCustomType


eventCodec : S.Codec e EventDefinition
eventCodec =
    S.customType
        (\eventEncoder value ->
            case value of
                Event.Event metadata data ->
                    eventEncoder metadata data
        )
        |> S.variant2 Event.Event eventMetadataCodec eventDataCodec
        |> S.finishCustomType


eventListCodec : S.Codec e SortedEventList.Model
eventListCodec =
    S.array eventCodec


serializeEvent : EventDefinition -> Json.Encode.Value
serializeEvent event =
    S.encodeToJson eventCodec event


deserializeEvent : Json.Encode.Value -> Result (S.Error e) EventDefinition
deserializeEvent serializedEvent =
    S.decodeFromJson eventCodec serializedEvent
