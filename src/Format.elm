module Format exposing (time)

import Time exposing (Posix)


time : Time.Posix -> String
time timeValue =
    (Time.toYear Time.utc timeValue
        |> String.fromInt
    )
        ++ "-"
        ++ (Time.toMonth Time.utc timeValue
                |> monthToNumber
                |> String.fromInt
           )
        ++ "-"
        ++ (Time.toDay
                Time.utc
                timeValue
                |> String.fromInt
           )
        ++ "T"
        ++ (Time.toHour Time.utc timeValue
                |> String.fromInt
           )
        ++ ":"
        ++ (Time.toMinute Time.utc timeValue
                |> String.fromInt
           )
        ++ ":"
        ++ (Time.toSecond Time.utc timeValue
                |> String.fromInt
           )
        ++ "Z"


monthToNumber : Time.Month -> Int
monthToNumber month =
    case month of
        Time.Jan ->
            1

        Time.Feb ->
            2

        Time.Mar ->
            3

        Time.Apr ->
            4

        Time.May ->
            5

        Time.Jun ->
            6

        Time.Jul ->
            7

        Time.Aug ->
            8

        Time.Sep ->
            9

        Time.Oct ->
            10

        Time.Nov ->
            11

        Time.Dec ->
            12
