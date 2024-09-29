module Evergreen.V7.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V7.Main.Layouts.Model
import Evergreen.V7.Main.Layouts.Msg
import Evergreen.V7.Main.Pages.Model
import Evergreen.V7.Main.Pages.Msg
import Evergreen.V7.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V7.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V7.Main.Layouts.Model.Model
    , shared : Evergreen.V7.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V7.Main.Pages.Msg.Msg
    | Layout Evergreen.V7.Main.Layouts.Msg.Msg
    | Shared Evergreen.V7.Shared.Msg
    | Batch (List Msg)
