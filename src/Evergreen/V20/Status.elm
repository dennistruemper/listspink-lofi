module Evergreen.V20.Status exposing (..)


type Status
    = Success (Maybe String)
    | Error String
