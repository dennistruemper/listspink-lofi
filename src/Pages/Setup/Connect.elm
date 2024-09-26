module Pages.Setup.Connect exposing (Model, Msg(..), page)

import Auth
import Bridge
import Effect exposing (Effect)
import Html
import Html.Attributes
import Html.Events
import Lamdera
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { codeInput : String
    , deviceName : String
    , validation : Maybe String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { codeInput = ""
      , deviceName = ""
      , validation = Nothing
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = CodeInputChanged String
    | DeviceNameChanged String
    | OkButtonClicked


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        CodeInputChanged codeInput ->
            let
                modelWithCode =
                    { model | codeInput = codeInput }
            in
            ( { modelWithCode | codeInput = codeInput, validation = validate shared modelWithCode }
            , Effect.none
            )

        DeviceNameChanged deviceName ->
            let
                modelWithDeviceName =
                    { model | deviceName = deviceName }
            in
            ( { modelWithDeviceName | deviceName = deviceName, validation = validate shared modelWithDeviceName }
            , Effect.none
            )

        OkButtonClicked ->
            let
                validation =
                    validate shared model
            in
            case ( validation, shared.nextIds ) of
                ( Nothing, Just nextIds ) ->
                    ( model, Effect.sendCmd <| Lamdera.sendToBackend (Bridge.UseSyncCode { code = model.codeInput, deviceId = nextIds.deviceId, deviceName = model.deviceName }) )

                _ ->
                    ( { model | validation = validation }, Effect.generateIds )


validate : Shared.Model -> Model -> Maybe String
validate shared model =
    if String.isEmpty model.codeInput then
        Just "Code is required"

    else if String.isEmpty model.deviceName then
        Just "Device name is required"

    else if shared.nextIds == Nothing then
        Just "No ids available. Try again."

    else
        Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Pages.Setup.Connect"
    , body =
        [ Html.input
            [ Html.Attributes.placeholder "Code"
            , Html.Attributes.value model.codeInput
            , Html.Events.onInput CodeInputChanged
            ]
            []
        , Html.input
            [ Html.Attributes.placeholder "Device Name"
            , Html.Attributes.value model.deviceName
            , Html.Events.onInput DeviceNameChanged
            ]
            []
        , Html.br [] []
        , Html.button
            [ Html.Events.onClick OkButtonClicked
            , Html.Attributes.disabled
                (case model.validation of
                    Just _ ->
                        True

                    Nothing ->
                        False
                )
            ]
            [ Html.text "OK" ]
        , Html.br [] []
        , Html.text (Maybe.withDefault "" model.validation)
        ]
    }
