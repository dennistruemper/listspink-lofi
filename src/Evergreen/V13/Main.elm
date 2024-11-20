module Evergreen.V13.Main exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V13.Main.Layouts.Model
import Evergreen.V13.Main.Layouts.Msg
import Evergreen.V13.Main.Pages.Model
import Evergreen.V13.Main.Pages.Msg
import Evergreen.V13.Shared
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Evergreen.V13.Main.Pages.Model.Model
    , layout : Maybe Evergreen.V13.Main.Layouts.Model.Model
    , shared : Evergreen.V13.Shared.Model
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Page Evergreen.V13.Main.Pages.Msg.Msg
    | Layout Evergreen.V13.Main.Layouts.Msg.Msg
    | Shared Evergreen.V13.Shared.Msg
    | Batch (List Msg)
