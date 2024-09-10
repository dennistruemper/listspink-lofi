module Pages.Manual exposing (Model, Msg, page)

import Bridge
import Components.Button as Button
import Effect exposing (Effect)
import Html
import Html.Attributes
import Html.Events
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import Shared.Msg
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { newUserId : String
    , newDeviceId : String
    , newUserName : String
    , newDeviceName : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { newUserId = ""
      , newDeviceId = ""
      , newUserName = ""
      , newDeviceName = ""
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = NewUseridChanged String
    | NewDeviceIdChanged String
    | NewUserNameChanged String
    | NewDeviceNameChanged String
    | CreateUserButtonClicked
    | AdminDataRequested
    | ReconnectUser


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NewUseridChanged value ->
            ( { model | newUserId = value }, Effect.none )

        NewDeviceIdChanged value ->
            ( { model | newDeviceId = value }, Effect.none )

        NewUserNameChanged value ->
            ( { model | newUserName = value }, Effect.none )

        NewDeviceNameChanged value ->
            ( { model | newDeviceName = value }, Effect.none )

        CreateUserButtonClicked ->
            let
                newUser =
                    Bridge.UserOnDevice
                        { userId = model.newUserId
                        , deviceId = model.newDeviceId
                        , deviceName = model.newDeviceName
                        , userName = model.newUserName
                        }
            in
            ( model
            , Effect.batch
                [ Effect.sendCmd <|
                    Lamdera.sendToBackend
                        (Bridge.NewUser
                            newUser
                        )
                , Effect.accountCreated newUser
                ]
            )

        AdminDataRequested ->
            ( model, Effect.sendCmd <| Lamdera.sendToBackend Bridge.RequestAdminData )

        ReconnectUser ->
            ( model
            , Effect.batch
                [ Effect.sendCmd <|
                    Lamdera.sendToBackend <|
                        Bridge.ReconnectUser { userId = model.newUserId, deviceId = model.newDeviceId }
                , Effect.accountCreated <|
                    Bridge.UserOnDevice
                        { userId = model.newUserId
                        , deviceId = model.newDeviceId
                        , deviceName = model.newDeviceName
                        , userName = model.newUserName
                        }
                ]
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Pages.Menual.NewUser"
    , body =
        [ Html.input
            [ Html.Attributes.placeholder "User ID"
            , Html.Attributes.value model.newUserId
            , Html.Events.onInput NewUseridChanged
            ]
            []
        , Html.input
            [ Html.Attributes.placeholder "Device ID"
            , Html.Attributes.value model.newDeviceId
            , Html.Events.onInput NewDeviceIdChanged
            ]
            []
        , Html.input
            [ Html.Attributes.placeholder "User Name"
            , Html.Attributes.value model.newUserName
            , Html.Events.onInput NewUserNameChanged
            ]
            []
        , Html.input
            [ Html.Attributes.placeholder "Device Name"
            , Html.Attributes.value model.newDeviceName
            , Html.Events.onInput NewDeviceNameChanged
            ]
            []
        , Button.button "Create" CreateUserButtonClicked |> Button.view
        , Button.button "Reconnect" ReconnectUser |> Button.view
        , Html.br [] []
        , Button.button "Request Admin Data" AdminDataRequested |> Button.view
        , Html.text "TODO AdminData" -- shared.adminData
        , Html.br [] []
        , Html.text ("Code:" ++ (shared.syncCode |> Maybe.map String.fromInt |> Maybe.withDefault "No code"))
        , Html.br [] []
        , Html.br [] []
        , Html.div [] [ Html.text "User:", viewUser shared.user ]
        , Html.br [] []
        , viewShared shared
        ]
    }


viewUser : Maybe Bridge.User -> Html.Html Msg
viewUser user =
    case user of
        Just (Bridge.UserOnDevice data) ->
            Html.div []
                [ Html.text ("User ID: " ++ data.userId)
                , Html.br [] []
                , Html.text ("Device ID: " ++ data.deviceId)
                , Html.br [] []
                , Html.text ("User Name: " ++ data.userName)
                , Html.br [] []
                , Html.text ("Device Name: " ++ data.deviceName)
                ]

        Just Bridge.Unknown ->
            Html.text "Unknown User"

        Nothing ->
            Html.text "No User Data Yet"


viewShared : Shared.Model -> Html.Html Msg
viewShared shared =
    Html.div []
        [ Html.text "Shared Model"
        , Html.br [] []
        , Html.div [] [ Html.text "User: ", viewUser shared.user ]
        , Html.br [] []
        , Html.text ("Sync Code: " ++ (shared.syncCode |> Maybe.map String.fromInt |> Maybe.withDefault "No code"))
        , Html.br [] []
        , Html.div [] [ Html.text "Next Ids:", viewNextIds shared.nextIds ]
        ]


viewNextIds : Maybe Shared.Model.NextIds -> Html.Html Msg
viewNextIds data =
    case data of
        Nothing ->
            Html.text "No Next Ids"

        Just ids ->
            Html.div []
                [ Html.text ("User Id: " ++ ids.userId)
                , Html.br [] []
                , Html.text ("Device Id: " ++ ids.deviceId)
                , Html.br [] []
                , Html.text ("Event Id: " ++ ids.eventId)
                , Html.br [] []
                , Html.text ("List Id: " ++ ids.listId)
                , Html.br [] []
                , Html.text ("Item Id: " ++ ids.itemId)
                ]
