module Evergreen.V4.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V4.Main.Layouts.Model
import Evergreen.V4.Main.Layouts.Msg
import Evergreen.V4.Main.Pages.Model
import Evergreen.V4.Main.Pages.Msg
import Evergreen.V4.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V4.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V4.Main.Layouts.Model.Model
    , shared : Evergreen.V4.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V4.Main.Pages.Msg.Msg
    | Layout Evergreen.V4.Main.Layouts.Msg.Msg
    | Shared Evergreen.V4.Shared.Msg
    | Batch (List Msg)
