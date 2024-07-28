module Pages.Setup.NewAccount exposing (Model, Msg, page)

import Bridge
import Effect exposing (Effect)
import Html
import Html.Attributes
import Html.Events
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update shared
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { userName : String
    , deviceName : String
    , validation : Maybe String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { userName = ""
      , deviceName = ""
      , validation = Nothing
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = Create
    | UsernameChanged String
    | DeviceNameChanged String


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        Create ->
            let
                validation =
                    validate shared model

                effect =
                    case shared.nextIds of
                        Nothing ->
                            Effect.none

                        Just nextIds ->
                            let
                                newUser =
                                    Bridge.UserOnDevice
                                        { userId = nextIds.userId
                                        , deviceId = nextIds.deviceId
                                        , deviceName = model.deviceName
                                        , userName = model.userName
                                        }
                            in
                            Effect.batch
                                [ Effect.accountCreated newUser
                                , Effect.generateIds
                                , Effect.sendCmd <|
                                    Lamdera.sendToBackend (Bridge.NewUser newUser)
                                ]
            in
            ( { model | validation = validation }
            , effect
            )

        UsernameChanged userName ->
            let
                modelWithNewUserName =
                    { model | userName = userName }
            in
            ( { modelWithNewUserName | userName = userName, validation = validate shared modelWithNewUserName }, Effect.none )

        DeviceNameChanged deviceName ->
            let
                modelWithNewDeviceName =
                    { model | deviceName = deviceName }
            in
            ( { modelWithNewDeviceName | deviceName = deviceName, validation = validate shared modelWithNewDeviceName }, Effect.none )


validate : Shared.Model -> Model -> Maybe String
validate shared model =
    if String.isEmpty model.userName then
        Just "Username is required"

    else if String.isEmpty model.deviceName then
        Just "Device Name is required"

    else if shared.nextIds == Nothing then
        Just "No new ids available"

    else
        Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Pages.Setup.NewAccount"
    , body =
        [ Html.h3 [] [ Html.text "Create new Account" ]
        , Html.input [ Html.Attributes.placeholder "Username", Html.Events.onInput UsernameChanged, Html.Attributes.value model.userName ] []
        , Html.input [ Html.Attributes.placeholder "Device Name", Html.Events.onInput DeviceNameChanged, Html.Attributes.value model.deviceName ] []
        , Html.button
            [ Html.Events.onClick Create
            , Html.Attributes.disabled
                (case model.validation of
                    Just _ ->
                        True

                    Nothing ->
                        False
                )
            ]
            [ Html.text "Create"
            ]
        , Html.br [] []
        , Html.text <| Maybe.withDefault "" model.validation
        ]
    }
