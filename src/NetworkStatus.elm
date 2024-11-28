module NetworkStatus exposing (NetworkStatus(..), decoder, encode)

import Json.Decode
import Json.Encode


type NetworkStatus
    = NetworkOnline
    | NetworkOffline
    | NetworkUnknown


decoder : Json.Decode.Decoder NetworkStatus
decoder =
    Json.Decode.string |> Json.Decode.andThen decode


decode : String -> Json.Decode.Decoder NetworkStatus
decode string =
    case string of
        "online" ->
            Json.Decode.succeed NetworkOnline

        "offline" ->
            Json.Decode.succeed NetworkOffline

        _ ->
            Json.Decode.succeed NetworkUnknown


encode : NetworkStatus -> Json.Encode.Value
encode networkStatus =
    case networkStatus of
        NetworkOnline ->
            Json.Encode.string "online"

        NetworkOffline ->
            Json.Encode.string "offline"

        NetworkUnknown ->
            Json.Encode.string "unknown"
