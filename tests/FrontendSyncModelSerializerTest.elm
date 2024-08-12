module FrontendSyncModelSerializerTest exposing (..)

import EventTestHelper
import Expect
import FrontendSyncModelSerializer
import Json.Encode
import Set
import SortedEventList
import Sync
import Test exposing (Test)
import Time


suite : Test
suite =
    Test.describe "event serializer"
        [ Test.test "event serializer is working for create list event" <|
            \() ->
                let
                    event =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    serializedEvent =
                        FrontendSyncModelSerializer.serializeEvent event

                    -- TODO look at json to compare if shorter than string
                    deserializedEvent =
                        FrontendSyncModelSerializer.deserializeEvent serializedEvent
                in
                Expect.equal (Ok event) deserializedEvent
        , Test.test "event serializer is working for frontendSyncModel" <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    event2 =
                        EventTestHelper.createEvent "event2" "aggregate2"

                    event3 =
                        EventTestHelper.createEvent "event3" "aggregate3"

                    event4 =
                        EventTestHelper.createEvent "event4" "aggregate4"

                    event5 =
                        EventTestHelper.createEvent "event5" "aggregate5"

                    syncModel =
                        Sync.initFrontend
                            |> Sync.addEventFromFrontend event1
                            |> Sync.addEventFromFrontend event2
                            |> Sync.addEventFromFrontend event3
                            |> Sync.addEventFromFrontend event4
                            |> Sync.addEventFromFrontend event5
                            |> (\model -> { model | lastSyncServerTime = Time.millisToPosix 123456789 })
                            |> (\model -> { model | unsyncedEventIds = Set.insert "event_123" model.unsyncedEventIds })
                            |> (\model -> { model | unsyncedEventIds = Set.insert "event_456" model.unsyncedEventIds })

                    serializedModel =
                        FrontendSyncModelSerializer.serializeFrontendSyncModel syncModel

                    deserializedModel =
                        FrontendSyncModelSerializer.deserializeFrontendSyncModel serializedModel
                in
                Expect.equal (Ok syncModel) deserializedModel
        ]
