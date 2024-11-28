module Evergreen.V21.Status exposing (..)


type Status
    = Success (Maybe String)
    | Error String
