module Evergreen.V21.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V21.Main.Layouts.Model
import Evergreen.V21.Main.Layouts.Msg
import Evergreen.V21.Main.Pages.Model
import Evergreen.V21.Main.Pages.Msg
import Evergreen.V21.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V21.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V21.Main.Layouts.Model.Model
    , shared : Evergreen.V21.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V21.Main.Pages.Msg.Msg
    | Layout Evergreen.V21.Main.Layouts.Msg.Msg
    | Shared Evergreen.V21.Shared.Msg
    | Batch (List Msg)
