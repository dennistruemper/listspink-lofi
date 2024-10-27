module EventTest exposing (..)

import Dict
import Event exposing (EventDefinition, State)
import EventTestHelper
import Expect
import Fuzz exposing (..)
import ItemPriority
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (..)
import Time


suite : Test
suite =
    describe "Event Tests - AI generated"
        [ describe "project"
            [ test "ListCreated event should create a new list" <|
                \_ ->
                    let
                        event =
                            EventTestHelper.createEvent "event1" "list1"

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items = Dict.empty
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 0
                                        , numberOfUpdates = 0
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ event ] initialState)
            , test "ListUpdated event should update an existing list" <|
                \_ ->
                    let
                        createEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        updateEvent =
                            Event.createListUpdatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { name = "updated name" }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "updated name"
                                        , listId = "list1"
                                        , items = Dict.empty
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 1
                                        , numberOfUpdates = 1
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createEvent, updateEvent ] initialState)
            , test "ListSharedWithUser event should add a user to the list" <|
                \_ ->
                    let
                        createEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        shareEvent =
                            Event.createListSharedWithUserEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { userId = "user1", listId = "list1" }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items = Dict.empty
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 0
                                        , numberOfUpdates = 0
                                        , users = [ "user1" ]
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createEvent, shareEvent ] initialState)
            ]
        , describe "Item events"
            [ test "ItemCreated event should add an item to the list" <|
                \_ ->
                    let
                        createListEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        createItemEvent =
                            Event.createItemCreatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { itemId = "item1"
                                , itemName = "New Item"
                                , itemDescription = Just "Description"
                                , itemPriority = Just ItemPriority.MediumItemPriority
                                }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items =
                                            Dict.fromList
                                                [ ( "item1"
                                                  , { name = "New Item"
                                                    , itemId = "item1"
                                                    , description = Just "Description"
                                                    , createdAt = Time.millisToPosix 1
                                                    , completedAt = Nothing
                                                    , lastUpdatedAt = Time.millisToPosix 1
                                                    , numberOfUpdates = 0
                                                    , priority = ItemPriority.MediumItemPriority
                                                    }
                                                  )
                                                ]
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 1
                                        , numberOfUpdates = 1
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createListEvent, createItemEvent ] initialState)
            , test "ItemUpdated event should update an existing item" <|
                \_ ->
                    let
                        createListEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        createItemEvent =
                            Event.createItemCreatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { itemId = "item1"
                                , itemName = "Original Item"
                                , itemDescription = Nothing
                                , itemPriority = Nothing
                                }

                        updateItemEvent =
                            Event.createItemUpdatedEvent
                                { eventId = "event3"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 2
                                }
                                { itemId = "item1"
                                , listId = "list1"
                                , name = Just "Updated Item"
                                , completed = Just (Just (Time.millisToPosix 2))
                                , itemPriority = Just ItemPriority.HighItemPriority
                                , description = Just "New Description"
                                }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items =
                                            Dict.fromList
                                                [ ( "item1"
                                                  , { itemId = "item1"
                                                    , name = "Updated Item"
                                                    , description = Just "New Description"
                                                    , priority = ItemPriority.HighItemPriority
                                                    , completedAt = Just (Time.millisToPosix 2)
                                                    , createdAt = Time.millisToPosix 1
                                                    , lastUpdatedAt = Time.millisToPosix 2
                                                    , numberOfUpdates = 1
                                                    }
                                                  )
                                                ]
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 2
                                        , numberOfUpdates = 2
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createListEvent, createItemEvent, updateItemEvent ] initialState)
            , test "ItemStateChanged event should update the completed state of an item" <|
                \_ ->
                    let
                        createListEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        createItemEvent =
                            Event.createItemCreatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { itemId = "item1"
                                , itemName = "Test Item"
                                , itemDescription = Nothing
                                , itemPriority = Nothing
                                }

                        changeItemStateEvent =
                            Event.createItemStateChangedEvent
                                { eventId = "event3"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 2
                                }
                                { itemId = "item1"
                                , newState = True
                                }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items =
                                            Dict.fromList
                                                [ ( "item1"
                                                  , { itemId = "item1"
                                                    , name = "Test Item"
                                                    , description = Nothing
                                                    , priority = ItemPriority.MediumItemPriority
                                                    , completedAt = Just (Time.millisToPosix 2)
                                                    , createdAt = Time.millisToPosix 1
                                                    , lastUpdatedAt = Time.millisToPosix 2
                                                    , numberOfUpdates = 1
                                                    }
                                                  )
                                                ]
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 2
                                        , numberOfUpdates = 2
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createListEvent, createItemEvent, changeItemStateEvent ] initialState)
            , test "Multiple ItemCreated events should add multiple items to the list" <|
                \_ ->
                    let
                        createListEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        createItemEvent1 =
                            Event.createItemCreatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { itemId = "item1"
                                , itemName = "Item 1"
                                , itemDescription = Nothing
                                , itemPriority = Just ItemPriority.LowItemPriority
                                }

                        createItemEvent2 =
                            Event.createItemCreatedEvent
                                { eventId = "event3"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 2
                                }
                                { itemId = "item2"
                                , itemName = "Item 2"
                                , itemDescription = Just "Description 2"
                                , itemPriority = Just ItemPriority.HighItemPriority
                                }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items =
                                            Dict.fromList
                                                [ ( "item1"
                                                  , { itemId = "item1"
                                                    , name = "Item 1"
                                                    , description = Nothing
                                                    , priority = ItemPriority.LowItemPriority
                                                    , completedAt = Nothing
                                                    , createdAt = Time.millisToPosix 1
                                                    , lastUpdatedAt = Time.millisToPosix 1
                                                    , numberOfUpdates = 0
                                                    }
                                                  )
                                                , ( "item2"
                                                  , { itemId = "item2"
                                                    , name = "Item 2"
                                                    , description = Just "Description 2"
                                                    , priority = ItemPriority.HighItemPriority
                                                    , completedAt = Nothing
                                                    , createdAt = Time.millisToPosix 2
                                                    , lastUpdatedAt = Time.millisToPosix 2
                                                    , numberOfUpdates = 0
                                                    }
                                                  )
                                                ]
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 2
                                        , numberOfUpdates = 2
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createListEvent, createItemEvent1, createItemEvent2 ] initialState)
            , test "ItemUpdated event should only update specified fields" <|
                \_ ->
                    let
                        createListEvent =
                            EventTestHelper.createEvent "event1" "list1"

                        createItemEvent =
                            Event.createItemCreatedEvent
                                { eventId = "event2"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 1
                                }
                                { itemId = "item1"
                                , itemName = "Original Item"
                                , itemDescription = Just "Original Description"
                                , itemPriority = Just ItemPriority.MediumItemPriority
                                }

                        updateItemEvent =
                            Event.createItemUpdatedEvent
                                { eventId = "event3"
                                , aggregateId = "list1"
                                , userId = "dummy"
                                , timestamp = Time.millisToPosix 2
                                }
                                { itemId = "item1"
                                , listId = "list1"
                                , name = Just "Updated Item"
                                , completed = Nothing
                                , itemPriority = Nothing
                                , description = Nothing
                                }

                        initialState =
                            Event.initialState

                        expectedState =
                            { lists =
                                Dict.fromList
                                    [ ( "list1"
                                      , { name = "dummy"
                                        , listId = "list1"
                                        , items =
                                            Dict.fromList
                                                [ ( "item1"
                                                  , { itemId = "item1"
                                                    , name = "Updated Item"
                                                    , description = Just "Original Description"
                                                    , priority = ItemPriority.MediumItemPriority
                                                    , completedAt = Nothing
                                                    , createdAt = Time.millisToPosix 1
                                                    , lastUpdatedAt = Time.millisToPosix 2
                                                    , numberOfUpdates = 1
                                                    }
                                                  )
                                                ]
                                        , createdAt = Time.millisToPosix 0
                                        , lastUpdatedAt = Time.millisToPosix 2
                                        , numberOfUpdates = 2
                                        , users = []
                                        }
                                      )
                                    ]
                            }
                    in
                    Expect.equal expectedState (Event.project [ createListEvent, createItemEvent, updateItemEvent ] initialState)
            ]
        ]
