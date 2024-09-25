module ItemPriority exposing (ItemPriority(..), all, compare_, itemPriorityFromString, itemPriorityToShortString, itemPriorityToString)


type ItemPriority
    = LowItemPriority
    | MediumItemPriority
    | HighItemPriority
    | HighestItemPriority


all =
    [ LowItemPriority, MediumItemPriority, HighItemPriority, HighestItemPriority ]


itemPriorityToShortString : ItemPriority -> String
itemPriorityToShortString priority =
    case priority of
        LowItemPriority ->
            "l"

        MediumItemPriority ->
            "m"

        HighItemPriority ->
            "h"

        HighestItemPriority ->
            "H"


itemPriorityToString : ItemPriority -> String
itemPriorityToString priority =
    case priority of
        LowItemPriority ->
            "Low"

        MediumItemPriority ->
            "Medium"

        HighItemPriority ->
            "High"

        HighestItemPriority ->
            "Highest"


itemPriorityFromString : String -> ItemPriority
itemPriorityFromString priority =
    case priority of
        "Low" ->
            LowItemPriority

        "Medium" ->
            MediumItemPriority

        "High" ->
            HighItemPriority

        "Highest" ->
            HighestItemPriority

        _ ->
            MediumItemPriority


compare_ : ItemPriority -> ItemPriority -> Order
compare_ a b =
    compare (sortOrderHelper a) (sortOrderHelper b)


sortOrderHelper : ItemPriority -> Int
sortOrderHelper priority =
    case priority of
        LowItemPriority ->
            0

        MediumItemPriority ->
            1

        HighItemPriority ->
            2

        HighestItemPriority ->
            3
