module Evergreen.V22.Status exposing (..)


type Status
    = Success (Maybe String)
    | Error String
