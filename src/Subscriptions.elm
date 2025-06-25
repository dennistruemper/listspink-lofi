module Subscriptions exposing (Model, Subscription, addSubscription, getSubscriptionsByAggregateId, getSubscriptionsByUserId, init, removeSubscription)

import Array exposing (Array)


type alias Subscription =
    { userId : String
    , aggregateId : String
    }


type alias Model =
    { subscriptions : Array Subscription
    }


init : Model
init =
    { subscriptions = Array.empty
    }


addSubscription : Subscription -> Model -> Model
addSubscription subscription model =
    let
        containsSubscription =
            Array.filter
                (\sub -> sub.userId == subscription.userId && sub.aggregateId == subscription.aggregateId)
                model.subscriptions
                |> (\arr -> Array.length arr > 0)
    in
    if containsSubscription then
        model

    else
        { model | subscriptions = Array.push subscription model.subscriptions }


removeSubscription : Subscription -> Model -> Model
removeSubscription subscription model =
    { model
        | subscriptions =
            Array.filter
                (\sub -> not (sub.userId == subscription.userId && sub.aggregateId == subscription.aggregateId))
                model.subscriptions
    }


getSubscriptionsByAggregateId : Model -> String -> List Subscription
getSubscriptionsByAggregateId model aggregateId =
    Array.filter (\sub -> sub.aggregateId == aggregateId) model.subscriptions |> Array.toList


getSubscriptionsByUserId : Model -> String -> List Subscription
getSubscriptionsByUserId model userId =
    Array.filter (\sub -> sub.userId == userId) model.subscriptions |> Array.toList
