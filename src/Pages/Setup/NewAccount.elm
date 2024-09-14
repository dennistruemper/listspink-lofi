module Pages.Setup.NewAccount exposing (Model, Msg, page)

import Bridge
import Components.Button as Button
import Components.Caption as Caption
import Components.Input as Input
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
        , view = view shared
        }



-- INIT


type alias Model =
    { userName : String
    , deviceName : String
    , validation : Maybe String
    , initialState : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { userName = ""
      , deviceName = ""
      , validation = Nothing
      , initialState = True
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = Create
    | UsernameChanged String
    | DeviceNameChanged String


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg incomingModel =
    let
        model =
            { incomingModel | initialState = False }
    in
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
    case
        [ validateUsername shared model
        , validateDeviceName shared model
        ]
            |> List.filterMap identity
    of
        [] ->
            Nothing

        errors ->
            Just <| String.join ", " errors


validateUsername : Shared.Model -> Model -> Maybe String
validateUsername shared model =
    if String.isEmpty model.userName && not model.initialState then
        Just "Username is required"

    else
        Nothing


validateDeviceName : Shared.Model -> Model -> Maybe String
validateDeviceName shared model =
    if String.isEmpty model.deviceName && not model.initialState then
        Just "Device Name is required"

    else
        Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        isCreateButtonDisabled =
            case model.validation of
                Just _ ->
                    True

                Nothing ->
                    False || model.initialState
    in
    { title = "Pages.Setup.NewAccount"
    , body =
        [ Html.div [ Html.Attributes.class "p-2 flex flex-col gap-2 max-w-lg lg:p-16 " ]
            [ Caption.caption1 "Create new Account" |> Caption.view
            , Input.text "Username" UsernameChanged (validateUsername shared model) model.userName |> Input.view
            , Input.text "Device Name" DeviceNameChanged (validateDeviceName shared model) model.deviceName |> Input.view
            , Button.button "Create" Create |> Button.withDisabled isCreateButtonDisabled |> Button.view
            ]
        ]
    }
