module Status exposing (Status(..), fromString, toString)


type Status
    = Success (Maybe String)
    | Error String


toString : Status -> String
toString status =
    case status of
        Success maybeMessage ->
            maybeMessage |> Maybe.map (\msg -> "Success: " ++ msg) |> Maybe.withDefault ""

        Error message ->
            "Error: " ++ message


fromString : String -> Maybe Status
fromString str =
    if String.startsWith "Error:" str then
        Error (String.dropLeft 6 str) |> Just

    else if String.startsWith "Success:" str then
        if String.dropLeft 7 str == "" then
            Just (Success Nothing)

        else
            Just (Success (Just (String.dropLeft 7 str)))

    else
        Nothing
