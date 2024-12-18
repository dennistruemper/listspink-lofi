module Evergreen.V19.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V19.Main.Layouts.Model
import Evergreen.V19.Main.Layouts.Msg
import Evergreen.V19.Main.Pages.Model
import Evergreen.V19.Main.Pages.Msg
import Evergreen.V19.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V19.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V19.Main.Layouts.Model.Model
    , shared : Evergreen.V19.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V19.Main.Pages.Msg.Msg
    | Layout Evergreen.V19.Main.Layouts.Msg.Msg
    | Shared Evergreen.V19.Shared.Msg
    | Batch (List Msg)
