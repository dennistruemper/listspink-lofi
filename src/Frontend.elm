module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Json.Encode
import Lamdera
import Main as ElmLand
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = ElmLand.init Json.Encode.null
        , onUrlRequest = ElmLand.UrlRequested
        , onUrlChange = ElmLand.UrlChanged
        , update = ElmLand.update
        , updateFromBackend = updateFromBackend
        , subscriptions = ElmLand.subscriptions
        , view = ElmLand.view
        }


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )
