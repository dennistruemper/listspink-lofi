module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Bridge
import Components.Toast
import Dict
import Effect exposing (Effect)
import Event
import EventMetadataHelper
import Json.Decode
import Lamdera
import NetworkStatus
import Ports
import Process
import Route exposing (Route)
import Route.Path
import Set
import Shared.Model
import Shared.Msg
import SortedEventList
import Status
import Subscriptions
import Sync
import Task
import UserManagement



-- FLAGS


type alias Flags =
    {}


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.succeed {}



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    ( { user = Nothing
      , syncCode = Nothing
      , nextIds = Nothing
      , syncModel = Sync.initFrontend
      , state = Event.initialState
      , menuOpen = False
      , version = Nothing
      , toasts = Components.Toast.init
      , networkStatus = NetworkStatus.NetworkUnknown
      }
    , Effect.batch [ Effect.generateIds, Effect.loadUserData, Effect.loadFrontendSyncModel, Effect.loadVersion ]
    )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


withSyncModelPersistence : ( Model, Effect Msg ) -> ( Model, Effect Msg )
withSyncModelPersistence ( model, effect ) =
    ( model, Effect.batch [ effect, Effect.storeFrontendSyncModel model.syncModel ] )


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.NewUserCreated user ->
            ( { model | user = Just user }, Effect.batch [ Effect.storeUserData user ] )

        Shared.Msg.GotSyncCode code ->
            ( { model | syncCode = Just code }, Effect.none )

        Shared.Msg.AddEvent event ->
            let
                newSyncModel =
                    Sync.addEventFromFrontend event model.syncModel
            in
            ( { model
                | syncModel = newSyncModel
                , state =
                    Event.project
                        (SortedEventList.getEvents newSyncModel.events)
                        Event.initialState
              }
            , Effect.batch [ Effect.generateIds, Effect.sendCmd <| Lamdera.sendToBackend <| Bridge.EventAdded event ]
            )
                |> withSyncModelPersistence

        Shared.Msg.GotUserData data ->
            let
                user =
                    Bridge.UserOnDevice
                        { userId = data.userId
                        , deviceId = data.deviceId
                        , deviceName = data.deviceName
                        , userName = data.name
                        , roles = data.roles
                        }
            in
            ( { model | user = Just user }, Effect.batch [ Effect.storeUserData user ] )

        Shared.Msg.ConnectionEstablished ->
            let
                requestNewEvents =
                    Effect.sendCmd <| Lamdera.sendToBackend <| Bridge.RequestNewEvents model.syncModel.lastSyncServerTime

                pushUnsyncedEvents =
                    Set.toList model.syncModel.unsyncedEventIds
                        |> List.filterMap
                            (\eventId ->
                                SortedEventList.findEvent eventId model.syncModel.events
                            )
                        |> List.map (\event -> Effect.sendCmd <| Lamdera.sendToBackend <| Bridge.EventAdded event)
            in
            ( model, Effect.batch (requestNewEvents :: pushUnsyncedEvents) )

        Shared.Msg.GotSyncResult result ->
            let
                newSyncModel =
                    Sync.addEventsFromBackend result.events
                        result.lastSyncServerTime
                        model.syncModel
            in
            ( { model | syncModel = newSyncModel, state = Event.project result.events model.state }, Effect.none )
                |> withSyncModelPersistence

        Shared.Msg.GotMessageFromJs message ->
            case Ports.decodeMsg message of
                Ports.IdsGenerated ids ->
                    ( { model | nextIds = Just ids }, Effect.none )

                Ports.UserDataLoaded userData ->
                    let
                        reconnectEffect =
                            case userData of
                                Bridge.Unknown ->
                                    Effect.none

                                Bridge.UserOnDevice user ->
                                    Effect.sendCmd <| Lamdera.sendToBackend <| Bridge.ReconnectUser { userId = user.userId, deviceId = user.deviceId }
                    in
                    ( { model | user = Just userData }, reconnectEffect )

                Ports.VersionLoaded version ->
                    ( { model | version = version }, Effect.none )

                Ports.UnknownMessage error ->
                    ( model, Effect.log error )

                Ports.FrontendSyncModelDataLoaded data ->
                    case data of
                        Ok syncModel ->
                            ( { model | syncModel = syncModel, state = Event.project (Sync.getEventsForFrontend syncModel) model.state }, Effect.none )

                        Err error ->
                            ( model, Effect.log error )

                Ports.UserLoggedOut ->
                    ( { model | user = Just Bridge.Unknown }, Effect.pushRoutePath Route.Path.Home_ )

                Ports.NetworkStatusLoaded networkStatus ->
                    let
                        effect =
                            if model.networkStatus /= NetworkStatus.NetworkUnknown && model.networkStatus /= networkStatus then
                                case networkStatus of
                                    NetworkStatus.NetworkOnline ->
                                        Effect.addToast (Components.Toast.info "You are back online")

                                    NetworkStatus.NetworkOffline ->
                                        Effect.addToast (Components.Toast.error "You are offline")

                                    _ ->
                                        Effect.none

                            else
                                Effect.none
                    in
                    ( { model | networkStatus = networkStatus }, effect )

        Shared.Msg.SidebarToggled newValue ->
            ( { model | menuOpen = newValue }, Effect.none )

        Shared.Msg.UserRolesUpdated data ->
            let
                updatedUser =
                    case model.user of
                        Just userData ->
                            case userData of
                                Bridge.UserOnDevice userOnDeviceData ->
                                    Just (Bridge.UserOnDevice { userOnDeviceData | roles = data.roles })

                                Bridge.Unknown ->
                                    Just userData

                        Nothing ->
                            Nothing

                effect =
                    updatedUser |> Maybe.map Effect.storeUserData |> Maybe.withDefault Effect.none
            in
            ( { model | user = updatedUser }, effect )

        Shared.Msg.AddToast toast ->
            let
                ( newToasts, toastId ) =
                    Components.Toast.addToast toast model.toasts

                effect =
                    Effect.sendCmd (Task.perform (\_ -> Shared.Msg.ToastMsg (Components.Toast.RemoveToast toastId)) (Process.sleep toast.duration))
            in
            ( { model | toasts = newToasts }, effect )

        Shared.Msg.ToastMsg toastMsg ->
            let
                newModel =
                    { model | toasts = Components.Toast.update toastMsg model.toasts }
            in
            ( newModel, Effect.none )

        Shared.Msg.NotAuthenticated ->
            ( model, Effect.addToast (Components.Toast.error "Not authenticated") )

        Shared.Msg.StatusResponse status id ->
            case status of
                Status.Success maybeMessage ->
                    ( model, Effect.addToast (Components.Toast.success (maybeMessage |> Maybe.withDefault "Success")) )

                Status.Error message ->
                    ( model, Effect.addToast (Components.Toast.error message) )

        Shared.Msg.NoOp ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.batch [ Ports.toElm Shared.Msg.GotMessageFromJs ]
