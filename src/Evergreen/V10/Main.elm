module Evergreen.V10.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V10.Main.Layouts.Model
import Evergreen.V10.Main.Layouts.Msg
import Evergreen.V10.Main.Pages.Model
import Evergreen.V10.Main.Pages.Msg
import Evergreen.V10.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V10.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V10.Main.Layouts.Model.Model
    , shared : Evergreen.V10.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V10.Main.Pages.Msg.Msg
    | Layout Evergreen.V10.Main.Layouts.Msg.Msg
    | Shared Evergreen.V10.Shared.Msg
    | Batch (List Msg)
