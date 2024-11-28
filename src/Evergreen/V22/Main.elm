module Evergreen.V22.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V22.Main.Layouts.Model
import Evergreen.V22.Main.Layouts.Msg
import Evergreen.V22.Main.Pages.Model
import Evergreen.V22.Main.Pages.Msg
import Evergreen.V22.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V22.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V22.Main.Layouts.Model.Model
    , shared : Evergreen.V22.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V22.Main.Pages.Msg.Msg
    | Layout Evergreen.V22.Main.Layouts.Msg.Msg
    | Shared Evergreen.V22.Shared.Msg
    | Batch (List Msg)
