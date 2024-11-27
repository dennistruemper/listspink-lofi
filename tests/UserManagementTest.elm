module UserManagementTest exposing (..)

import Dict exposing (Dict)
import Expect exposing (..)
import Role
import Test exposing (..)
import Time
import UserManagement


defaultTime : Time.Posix
defaultTime =
    Time.millisToPosix 123456789


aliceDeviceId : String
aliceDeviceId =
    "1"


alice : UserManagement.UserOnDeviceData
alice =
    { userId = "1", deviceId = aliceDeviceId, deviceName = "Phone of Alice", userName = "Alice", roles = [ Role.User ] }


bob : UserManagement.UserOnDeviceData
bob =
    { userId = "20", deviceId = "20", userName = "Bob", deviceName = "Phone of Bob", roles = [ Role.User ] }


charly : UserManagement.UserOnDeviceData
charly =
    { userId = "30", deviceId = "30", userName = "Charly", deviceName = "Phone of Charly", roles = [ Role.User ] }


withDevice : String -> String -> UserManagement.UserOnDeviceData -> UserManagement.UserOnDeviceData
withDevice deviceId deviceName user =
    { user | deviceId = deviceId, deviceName = deviceName }


suite : Test
suite =
    Test.describe "UserManagement"
        [ Test.describe "addDeviceDataToUser"
            [ test "Add user to initial state does not work" <|
                \_ ->
                    let
                        user : UserManagement.UserOnDeviceData
                        user =
                            alice

                        model =
                            UserManagement.init

                        newModel =
                            UserManagement.addDeviceDataToUser "sessionA" user defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    Nothing
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectSessionCount
                        ]
                        newModel
            , test "Add device to existing user" <|
                \_ ->
                    let
                        model =
                            UserManagement.init |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.addDeviceDataToUser "sessionA" (alice |> withDevice "2" "Laptop of Alice") defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            , { deviceId = "2", name = "Laptop of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectSessionCount
                        ]
                        newModel
            ]
        , Test.describe "getOtherSessionsForUser"
            [ test "Get other sessions for not existing user" <|
                \_ ->
                    let
                        model =
                            UserManagement.init

                        otherSessions =
                            UserManagement.getOtherSessionsForUser "sessionB" model

                        expect =
                            \result ->
                                Expect.equal
                                    []
                                    result
                    in
                    expect otherSessions
            , test "Get other sessions for user with one session" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addDeviceDataToUser
                                    "sessionA"
                                    (alice |> withDevice "4" "Tablet of Alice")
                                    defaultTime

                        otherSessions =
                            UserManagement.getOtherSessionsForUser "sessionA" model

                        expect =
                            \result ->
                                Expect.equal
                                    []
                                    result
                    in
                    expect otherSessions
            , test "Get other sessions for user with multiple sessions" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addDeviceDataToUser
                                    "sessionA"
                                    (alice |> withDevice "4" "Phone of Alice")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionB"
                                    (alice |> withDevice "5" "Tablet of Alice")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionC"
                                    (alice |> withDevice "6" "Laptop of Alice")
                                    defaultTime

                        otherSessions =
                            UserManagement.getOtherSessionsForUser "sessionA" model

                        expect =
                            \result ->
                                Expect.equal
                                    [ "sessionB", "sessionC" ]
                                    result
                    in
                    expect otherSessions
            , test "Get other sessions for user with multiple sessions and other users" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addDeviceDataToUser
                                    "sessionA"
                                    (alice |> withDevice "4" "Phone of Alice")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionB"
                                    (alice |> withDevice "5" "Tablet of Alice")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionC"
                                    (alice |> withDevice "6" "Laptop of Alice")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionD"
                                    (bob |> withDevice "7" "Phone of Bob")
                                    defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionE"
                                    (charly |> withDevice "8" "Phone of Charly")
                                    defaultTime

                        otherSessions =
                            UserManagement.getOtherSessionsForUser "sessionA" model

                        expect =
                            \result ->
                                Expect.equal
                                    [ "sessionB", "sessionC" ]
                                    result
                    in
                    expect otherSessions
            ]
        , Test.describe "addUser"
            [ test "Add user to initial state" <|
                \_ ->
                    let
                        model =
                            UserManagement.init

                        newModel =
                            UserManagement.addUser "sessionA" alice defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices = [ { deviceId = alice.deviceId, name = alice.deviceName } ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectSessionCount
                        ]
                        newModel
            , test "Add new user to state with existing user" <|
                \_ ->
                    let
                        model =
                            UserManagement.init |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.addUser "sessionB" bob defaultTime model

                        expectUserBob =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = bob.userName
                                        , devices = [ { deviceId = bob.deviceId, name = bob.deviceName } ]
                                        , userId = bob.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionB"
                                        result
                                    )

                        expectUserAlice =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices = [ { deviceId = alice.deviceId, name = alice.deviceName } ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    2
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUserBob
                        , expectUserAlice
                        , expectSessionCount
                        ]
                        newModel
            , test "Add user second time does not work" <|
                \_ ->
                    let
                        model =
                            UserManagement.init |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.addUser "sessionB" alice defaultTime model

                        expectUserAlice =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices = [ { deviceId = alice.deviceId, name = alice.deviceName } ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectNoSessionB =
                            \result ->
                                Expect.equal
                                    Nothing
                                    (UserManagement.getUserForSession
                                        "sessionB"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUserAlice
                        , expectNoSessionB
                        , expectSessionCount
                        ]
                        newModel
            , test "Add new user with same session does not work" <|
                \_ ->
                    let
                        model =
                            UserManagement.init |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.addUser "sessionA" bob defaultTime model

                        expectUserAlice =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices = [ { deviceId = alice.deviceId, name = alice.deviceName } ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectNoSessionB =
                            \result ->
                                Expect.equal
                                    Nothing
                                    (UserManagement.getUserForSession
                                        "sessionB"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUserAlice
                        , expectNoSessionB
                        , expectSessionCount
                        ]
                        newModel
            ]
        , Test.describe "reconnect user on device"
            [ test "Reconnect user with correct device id works" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.reconnectUserOnDevice "sessionB" { userId = alice.userId, deviceId = aliceDeviceId } defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionB"
                                        result
                                    )

                        expectNoSessionA =
                            \result ->
                                UserManagement.getUserForSession
                                    "sessionA"
                                    result
                                    |> Expect.equal Nothing

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectNoSessionA
                        , expectSessionCount
                        ]
                        newModel
            , test "Reconnect user with wrong device id does not work" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.reconnectUserOnDevice "sessionB" { userId = alice.userId, deviceId = "wrong" } defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectNoSessionB =
                            \result ->
                                UserManagement.getUserForSession
                                    "sessionB"
                                    result
                                    |> Expect.equal Nothing

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectNoSessionB
                        , expectSessionCount
                        ]
                        newModel
            , test "Reconnect user with correct device id and multiple devices works" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addUser "sessionA" alice defaultTime
                                |> UserManagement.addDeviceDataToUser
                                    "sessionB"
                                    (alice |> withDevice "2" "Laptop of Alice")
                                    defaultTime

                        newModel =
                            UserManagement.reconnectUserOnDevice "sessionC" { userId = alice.userId, deviceId = "2" } defaultTime model

                        expectUserForSessionA =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            , { deviceId = "2", name = "Laptop of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectUserForSessionC =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            , { deviceId = "2", name = "Laptop of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectNoSessionB =
                            \result ->
                                UserManagement.getUserForSession
                                    "sessionB"
                                    result
                                    |> Expect.equal Nothing

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    2
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectNoSessionB
                        , expectUserForSessionA
                        , expectUserForSessionC
                        , expectSessionCount
                        ]
                        newModel
            , test "Reconnect User for existing session does nothing" <|
                \_ ->
                    let
                        model =
                            UserManagement.init
                                |> UserManagement.addUser "sessionA" alice defaultTime

                        newModel =
                            UserManagement.reconnectUserOnDevice "sessionA" { userId = alice.userId, deviceId = aliceDeviceId } defaultTime model

                        expectUser =
                            \result ->
                                Expect.equal
                                    (Just
                                        { name = alice.userName
                                        , devices =
                                            [ { deviceId = "1", name = "Phone of Alice" }
                                            ]
                                        , userId = alice.userId
                                        , syncInProgress = Nothing
                                        , roles = [ Role.Admin, Role.User ]
                                        }
                                    )
                                    (UserManagement.getUserForSession
                                        "sessionA"
                                        result
                                    )

                        expectSessionCount =
                            \result ->
                                Expect.equal
                                    1
                                    (UserManagement.getSessionCount result)
                    in
                    Expect.all
                        [ expectUser
                        , expectSessionCount
                        ]
                        newModel
            ]
        ]
