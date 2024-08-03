module SyncTest exposing (..)

import Array
import Event exposing (EventDefinition)
import EventTestHelper
import Expect
import Subscriptions
import Sync
import Test exposing (Test)
import Time
import UserManagement


type alias SyncTestEvent =
    { eventId : String
    , aggregateId : String
    }


getEventId : SyncTestEvent -> String
getEventId e =
    e.eventId


getAggregateId : SyncTestEvent -> String
getAggregateId e =
    e.aggregateId



-- Default config is with 3 Users:
-- Alice with 1 Device
-- Bob with 2 Devices
-- Charlie with 3 Devices


type alias DeviceData =
    { sessionId : String
    , deviceId : String
    }


alice : { device1 : DeviceData, userId : String }
alice =
    { device1 = { sessionId = "Alice1Session", deviceId = "Alice1" }, userId = "Alice" }


bob : { device1 : DeviceData, device2 : DeviceData, userId : String }
bob =
    { device1 = { sessionId = "Bob1Session", deviceId = "Bob1" }
    , device2 = { sessionId = "Bob2Session", deviceId = "Bob2" }
    , userId = "Bob"
    }


charlie : { device1 : DeviceData, device2 : DeviceData, device3 : DeviceData, userId : String }
charlie =
    { device1 = { sessionId = "Charlie1Session", deviceId = "Charlie1" }
    , device2 = { sessionId = "Charlie2Session", deviceId = "Charlie2" }
    , device3 = { sessionId = "Charlie3Session", deviceId = "Charlie3" }
    , userId = "Charlie"
    }


userOnDeviceData : String -> String -> UserManagement.UserOnDeviceData
userOnDeviceData userId deviceId =
    { userId = userId, deviceId = deviceId, deviceName = deviceId, userName = userId }


defaultUserManagement : UserManagement.Model
defaultUserManagement =
    UserManagement.init
        |> UserManagement.addUser alice.device1.sessionId
            (userOnDeviceData alice.userId alice.device1.deviceId)
            (Time.millisToPosix 0)
        |> UserManagement.addUser bob.device1.sessionId
            (userOnDeviceData bob.userId bob.device1.deviceId)
            (Time.millisToPosix 0)
        |> UserManagement.addDeviceDataToUser bob.device2.sessionId
            (userOnDeviceData bob.userId bob.device2.deviceId)
            (Time.millisToPosix 0)
        |> UserManagement.addUser charlie.device1.sessionId
            (userOnDeviceData charlie.userId charlie.device1.deviceId)
            (Time.millisToPosix 0)
        |> UserManagement.addDeviceDataToUser charlie.device2.sessionId
            (userOnDeviceData charlie.userId charlie.device2.deviceId)
            (Time.millisToPosix 0)
        |> UserManagement.addDeviceDataToUser charlie.device3.sessionId
            (userOnDeviceData charlie.userId charlie.device3.deviceId)
            (Time.millisToPosix 0)



-- default subscriptions
-- everyone has one unique item
-- bob and alice share one item


defaultSubscriptions : Subscriptions.Model
defaultSubscriptions =
    Subscriptions.init
        |> Subscriptions.addSubscription { userId = alice.userId, aggregateId = alice.userId ++ "1" }
        |> Subscriptions.addSubscription { userId = bob.userId, aggregateId = bob.userId ++ "1" }
        |> Subscriptions.addSubscription { userId = charlie.userId, aggregateId = charlie.userId ++ "1" }
        |> Subscriptions.addSubscription { userId = alice.userId, aggregateId = alice.userId ++ bob.userId ++ "1" }
        |> Subscriptions.addSubscription { userId = bob.userId, aggregateId = alice.userId ++ bob.userId ++ "1" }


defaultBackendModel : Sync.BackendSyncModel
defaultBackendModel =
    Sync.initBackend


defaultFrontendModel : Sync.FrontendSyncModel
defaultFrontendModel =
    Sync.initFrontend


suite : Test
suite =
    Test.describe "Sync Testing Suite"
        [ Test.describe "Subscriptions"
            [ Test.test "Get Alice device if alice sends event for her aggregation id" <|
                \() ->
                    let
                        --arrange
                        event =
                            EventTestHelper.createEvent "e1" (alice.userId ++ "1")

                        -- act
                        resultValue =
                            Sync.addEventToBackend event (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel

                        -- assert
                        expectSessions =
                            \result ->
                                Expect.equal [ { sessionId = alice.device1.sessionId } ] result.subscribedSessions
                    in
                    Expect.all
                        [ expectSessions
                        ]
                        resultValue

            --
            , Test.test "Get Bobs devices sessions if bob sends event for his aggregation id" <|
                \() ->
                    let
                        --arrange
                        event =
                            EventTestHelper.createEvent "e1" (bob.userId ++ "1")

                        -- act
                        resultValue =
                            Sync.addEventToBackend event (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel

                        -- assert
                        expectSessions =
                            \result ->
                                Expect.equal [ { sessionId = bob.device1.sessionId }, { sessionId = bob.device2.sessionId } ] result.subscribedSessions
                    in
                    Expect.all
                        [ expectSessions
                        ]
                        resultValue

            --
            , Test.test "Get Alice and Bobs session if event for their aggregation id is send" <|
                \() ->
                    let
                        --arrange
                        event =
                            EventTestHelper.createEvent "e1" (alice.userId ++ bob.userId ++ "1")

                        -- act
                        resultValue =
                            Sync.addEventToBackend event (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel

                        -- assert
                        expectSessions =
                            \result ->
                                Expect.equal [ { sessionId = alice.device1.sessionId }, { sessionId = bob.device1.sessionId }, { sessionId = bob.device2.sessionId } ] result.subscribedSessions
                    in
                    Expect.all
                        [ expectSessions
                        ]
                        resultValue
            ]
        , Test.describe "Event Storage"
            [ Test.test "New Event should be stored in Backend" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event =
                            EventTestHelper.createEvent "e1" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    [ { event = event, serverTime = Time.millisToPosix 0 }
                                    ]
                                    (Sync.getEventsForAggregateId
                                        aggregateId
                                        result.newBackendModel
                                    )
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue

            --
            , Test.test "Duplicate Event (same event id) should not be stored in Backend" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event1 =
                            EventTestHelper.createEvent "e1" aggregateId

                        event2 =
                            EventTestHelper.createEvent "e1" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    [ { event = event1, serverTime = Time.millisToPosix 0 }
                                    ]
                                    (Sync.getEventsForAggregateId
                                        aggregateId
                                        result.newBackendModel
                                    )
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue

            --
            , Test.test "Other event id should store other value to same aggregate" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event1 =
                            EventTestHelper.createEvent "e1" aggregateId

                        event2 =
                            EventTestHelper.createEvent "e2" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    [ { event = event1, serverTime = Time.millisToPosix 0 }
                                    , { event = event2, serverTime = Time.millisToPosix 1 }
                                    ]
                                    (Sync.getEventsForAggregateId
                                        aggregateId
                                        result.newBackendModel
                                    )
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue

            --
            , Test.test "Other aggregate id should add to other aggregate " <|
                \() ->
                    let
                        --arrange
                        event1 =
                            EventTestHelper.createEvent "e1" "a1"

                        event2 =
                            EventTestHelper.createEvent "e2" "a2"

                        event3 =
                            EventTestHelper.createEvent "e3" "a1"

                        event4 =
                            EventTestHelper.createEvent "e4" "a2"

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.addEventToBackend event3 (Time.millisToPosix 2) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.addEventToBackend event4 (Time.millisToPosix 3) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectA1Events =
                            \result ->
                                Expect.equal
                                    [ { event = event1, serverTime = Time.millisToPosix 0 }
                                    , { event = event3, serverTime = Time.millisToPosix 2 }
                                    ]
                                    (Sync.getEventsForAggregateId
                                        "a1"
                                        result.newBackendModel
                                    )
                    in
                    Expect.all
                        [ expectA1Events
                        ]
                        resultValue
            ]
        , Test.describe "Partial sync initialized by client"
            [ Test.test "Partial sync should return all events for Zero time" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event1 =
                            EventTestHelper.createEvent "e1" aggregateId

                        event2 =
                            EventTestHelper.createEvent "e2" aggregateId

                        event3 =
                            EventTestHelper.createEvent "e3" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.addEventToBackend event3 (Time.millisToPosix 2) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.getNewEventsForUser alice.device1.sessionId (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    [ event1
                                    , event2
                                    , event3
                                    ]
                                    result
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue
            , Test.test "Partial sync should only return newer or equal events" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event1 =
                            EventTestHelper.createEvent "e1" aggregateId

                        event2 =
                            EventTestHelper.createEvent "e2" aggregateId

                        event3 =
                            EventTestHelper.createEvent "e3" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.addEventToBackend event3 (Time.millisToPosix 2) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.getNewEventsForUser alice.device1.sessionId (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    [ event2
                                    , event3
                                    ]
                                    result
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue
            , Test.test "Partial sync should return nothing for other user (charlie)" <|
                \() ->
                    let
                        --arrange
                        aggregateId =
                            alice.userId ++ bob.userId ++ "1"

                        event1 =
                            EventTestHelper.createEvent "e1" aggregateId

                        event2 =
                            EventTestHelper.createEvent "e2" aggregateId

                        event3 =
                            EventTestHelper.createEvent "e3" aggregateId

                        -- act
                        resultValue =
                            Sync.addEventToBackend event1 (Time.millisToPosix 0) defaultSubscriptions defaultUserManagement defaultBackendModel
                                |> (\tempResult -> Sync.addEventToBackend event2 (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.addEventToBackend event3 (Time.millisToPosix 2) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)
                                |> (\tempResult -> Sync.getNewEventsForUser charlie.device1.sessionId (Time.millisToPosix 1) defaultSubscriptions defaultUserManagement tempResult.newBackendModel)

                        -- assert
                        expectEvents =
                            \result ->
                                Expect.equal
                                    []
                                    result
                    in
                    Expect.all
                        [ expectEvents
                        ]
                        resultValue
            ]
        ]
