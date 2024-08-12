module SubscriptionsTest exposing (..)

import Expect
import Subscriptions
import Test exposing (Test)


sub_UsrA_Agg1 : Subscriptions.Subscription
sub_UsrA_Agg1 =
    { userId = "A"
    , aggregateId = "1"
    }


sub_UsrA_Agg2 : Subscriptions.Subscription
sub_UsrA_Agg2 =
    { userId = "A"
    , aggregateId = "2"
    }


sub_UsrB_Agg1 : Subscriptions.Subscription
sub_UsrB_Agg1 =
    { userId = "B"
    , aggregateId = "1"
    }


sub_UsrB_Agg2 : Subscriptions.Subscription
sub_UsrB_Agg2 =
    { userId = "B"
    , aggregateId = "2"
    }


suite : Test
suite =
    Test.describe "Subscriptions"
        [ Test.test "addSubscription and get it back by userId" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                in
                Expect.equal [ sub_UsrA_Agg1 ] (Subscriptions.getSubscriptionsByUserId model sub_UsrA_Agg1.userId)

        --
        , Test.test "addSubscription and get empty list by unknown userId" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                in
                Expect.equal [] (Subscriptions.getSubscriptionsByUserId model "unknownId")

        --
        , Test.test "addSubscription and get it back by aggregateId" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                in
                Expect.equal [ sub_UsrA_Agg1 ] (Subscriptions.getSubscriptionsByAggregateId model sub_UsrA_Agg1.aggregateId)

        --
        , Test.test "addSubscription and get empty list by unknown aggregateId" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                in
                Expect.equal [] (Subscriptions.getSubscriptionsByAggregateId model "unknownId")

        --
        , Test.test "addSubscription already existsting subscription - no extra entry" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                in
                Expect.equal [ sub_UsrA_Agg1 ]
                    (Subscriptions.getSubscriptionsByUserId model sub_UsrA_Agg1.userId)

        --
        , Test.test "addSubscription other subscription for same user gets 2 entries" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                            |> Subscriptions.addSubscription sub_UsrA_Agg2
                in
                Expect.equal [ sub_UsrA_Agg1, sub_UsrA_Agg2 ] (Subscriptions.getSubscriptionsByUserId model sub_UsrA_Agg1.userId)

        --
        , Test.test "addSubscription other subscription for same user gets 2 entries - entries for other user are ignored" <|
            \() ->
                let
                    model =
                        Subscriptions.init
                            |> Subscriptions.addSubscription sub_UsrA_Agg1
                            |> Subscriptions.addSubscription sub_UsrA_Agg2
                            |> Subscriptions.addSubscription sub_UsrB_Agg1
                            |> Subscriptions.addSubscription sub_UsrB_Agg2
                in
                Expect.equal [ sub_UsrA_Agg1, sub_UsrA_Agg2 ] (Subscriptions.getSubscriptionsByUserId model sub_UsrA_Agg1.userId)
        ]
