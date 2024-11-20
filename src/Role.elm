module Role exposing
    ( Role(..)
    , decoder
    , encode
    , fromString
    , toString
    )

import Json.Decode as D
import Json.Encode as E


type Role
    = User
    | Admin


toString : Role -> String
toString role =
    case role of
        User ->
            "user"

        Admin ->
            "admin"


fromString : String -> Maybe Role
fromString str =
    case String.toLower str of
        "user" ->
            Just User

        "admin" ->
            Just Admin

        _ ->
            Nothing


encode : Role -> E.Value
encode role =
    E.string (toString role)


decoder : D.Decoder Role
decoder =
    D.string
        |> D.andThen
            (\str ->
                case fromString str of
                    Just role ->
                        D.succeed role

                    Nothing ->
                        D.fail ("Invalid role: " ++ str)
            )
