module Pages.Setup.Connect exposing (Model, Msg(..), page)

import Auth
import Bridge
import Components.AppBar as AppBar
import Components.Button as Button
import Components.Input as Input
import Dict
import Effect exposing (Effect)
import Html
import Html.Attributes
import Html.Events
import Lamdera
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


title =
    "Connect Device"


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init shared route
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { codeInput : String
    , deviceName : String
    , validation : Maybe String
    , redirect : Maybe String
    }


init : Shared.Model -> Route () -> () -> ( Model, Effect Msg )
init shared route () =
    ( { codeInput = ""
      , deviceName = ""
      , validation = Just ""
      , redirect = Dict.get "from" route.query
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
                    let
                        redirect =
                            case model.redirect of
                                Just from ->
                                    Effect.replaceRoutePath (Route.Path.fromString from |> Maybe.withDefault Route.Path.Home_)

                                Nothing ->
                                    Effect.replaceRoutePath Route.Path.Home_
                    in
                    ( model
                    , Effect.batch
                        [ Effect.sendCmd <| Lamdera.sendToBackend (Bridge.UseSyncCode { code = model.codeInput, deviceId = nextIds.deviceId, deviceName = model.deviceName })
                        , redirect
                        ]
                    )

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
    { title = title
    , body =
        [ AppBar.appBar
            |> AppBar.withContent
                [ Input.text "Code" CodeInputChanged Nothing model.codeInput
                    |> Input.view
                , Input.text "Device Name" DeviceNameChanged Nothing model.deviceName
                    |> Input.view
                , Html.text (Maybe.withDefault "" model.validation)
                ]
            |> AppBar.withActions
                [ Button.button "OK" OkButtonClicked
                    |> Button.withDisabled (model.validation /= Nothing)
                    |> Button.view
                ]
            |> AppBar.view
        ]
    }
