module Evergreen.V12.Pages.Share.ListId_ exposing (..)

import Time


type States
    = InitializingSync
    | Syncing
    | DoneSyncing
    | ErrorSyncing String


type alias Model =
    { listId : String
    , state : States
    }


type Msg
    = GotListSubscriptionAdded
        { userId : String
        , listId : String
        , timestamp : Time.Posix
        }
    | GotListSubscriptionFailed
    | TimeoutSubscriptionWait
    | GoBackClicked
