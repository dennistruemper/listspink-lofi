module PortsTest exposing (..)

import Bridge
import Expect
import Ports
import Role exposing (Role)
import Test exposing (Test)


suite : Test
suite =
    Test.describe "decode Mesage from JS"
        [ Test.test "decode valid IdsGenerated" <|
            \() ->
                let
                    json =
                        "{ \"tag\": \"IdsGenerated\", \"data\": { \"userId\": \"123\", \"deviceId\": \"456\", \"eventId\": \"789\", \"listId\": \"012\", \"itemId\": \"345\" } }"

                    expected =
                        Ports.IdsGenerated { userId = "123", deviceId = "456", eventId = "789", listId = "012", itemId = "345" }
                in
                Expect.equal expected (Ports.decodeMsg json)
        , Test.test "decode incomplete GenaerateIds" <|
            \() ->
                let
                    json =
                        "{ \"tag\": \"IdsGenerated\", \"data\": { \"user\": \"123\", \"device\": \"456\" } }"

                    expected =
                        Ports.UnknownMessage "Could not decodedata for IdsGenerated: Problem with the value at json.data:\n\n    {\n        \"user\": \"123\",\n        \"device\": \"456\"\n    }\n\nExpecting an OBJECT with a field named `itemId`"
                in
                Expect.equal expected (Ports.decodeMsg json)
        , Test.test "decode invalid tag" <|
            \() ->
                let
                    json =
                        "{ \"tag\": \"BlaBla\" }"

                    expected =
                        Ports.UnknownMessage "tag is unknown: BlaBla"
                in
                Expect.equal expected (Ports.decodeMsg json)
        , Test.test "decode valid UserDataLoaded" <|
            \() ->
                let
                    json =
                        "{ \"tag\": \"UserDataLoaded\", \"data\": { \"userId\": \"123\", \"deviceId\": \"456\", \"deviceName\": \"device\", \"userName\": \"user\" } }"

                    expected =
                        Ports.UserDataLoaded (Bridge.UserOnDevice { userId = "123", deviceId = "456", deviceName = "device", userName = "user", roles = [] })
                in
                Expect.equal expected (Ports.decodeMsg json)
        , Test.test "decode missing UserDataLoaded" <|
            \() ->
                let
                    json =
                        "{ \"tag\": \"UserDataLoaded\", \"data\": {} }"

                    expected =
                        Ports.UserDataLoaded Bridge.Unknown
                in
                Expect.equal expected (Ports.decodeMsg json)
        ]
