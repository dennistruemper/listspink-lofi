module SortedEventListTest exposing (..)

import EventTestHelper
import Expect
import SortedEventList
import Test exposing (Test)
import Time


suite : Test
suite =
    Test.describe "SortedEventList"
        [ Test.test "initialized is empty list" <|
            \() ->
                let
                    model =
                        SortedEventList.init
                in
                Expect.equal (SortedEventList.getEvents model) []
        , Test.test "add two events in correct order" <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    event2 =
                        EventTestHelper.createEvent "event2" "aggregate2" |> EventTestHelper.withTime (Time.millisToPosix 1)

                    model =
                        SortedEventList.addEvent event1 SortedEventList.init
                            |> SortedEventList.addEvent event2
                in
                Expect.equal (SortedEventList.getEvents model) [ event1, event2 ]
        , Test.test "add three events in wrong order results in correct order" <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    event2 =
                        EventTestHelper.createEvent "event2" "aggregate2" |> EventTestHelper.withTime (Time.millisToPosix 1)

                    event3 =
                        EventTestHelper.createEvent "event3" "aggregate3" |> EventTestHelper.withTime (Time.millisToPosix 2)

                    model =
                        SortedEventList.addEvent event3 SortedEventList.init
                            |> SortedEventList.addEvent event2
                            |> SortedEventList.addEvent event1
                in
                Expect.equal (SortedEventList.getEvents model) [ event1, event2, event3 ]
        , Test.test "add three events in correct order results in correct order" <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    event2 =
                        EventTestHelper.createEvent "event2" "aggregate2" |> EventTestHelper.withTime (Time.millisToPosix 1)

                    event3 =
                        EventTestHelper.createEvent "event3" "aggregate3" |> EventTestHelper.withTime (Time.millisToPosix 2)

                    model =
                        SortedEventList.addEvent event1 SortedEventList.init
                            |> SortedEventList.addEvent event2
                            |> SortedEventList.addEvent event3
                in
                Expect.equal (SortedEventList.getEvents model) [ event1, event2, event3 ]
        , Test.test "add three events in correct order but 2+3 at same time results in correct order " <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    event2 =
                        EventTestHelper.createEvent "event2" "aggregate2" |> EventTestHelper.withTime (Time.millisToPosix 5)

                    event3 =
                        EventTestHelper.createEvent "event3" "aggregate3" |> EventTestHelper.withTime (Time.millisToPosix 5)

                    model =
                        SortedEventList.addEvent event1 SortedEventList.init
                            |> SortedEventList.addEvent event3
                            |> SortedEventList.addEvent event2
                in
                Expect.equal (SortedEventList.getEvents model) [ event1, event3, event2 ]
        , Test.test "duplicate event id is not inserted" <|
            \() ->
                let
                    event1 =
                        EventTestHelper.createEvent "event1" "aggregate1"

                    model =
                        SortedEventList.addEvent event1 SortedEventList.init
                            |> SortedEventList.addEvent event1
                            |> SortedEventList.addEvent event1
                in
                Expect.equal (SortedEventList.getEvents model) [ event1 ]
        ]
