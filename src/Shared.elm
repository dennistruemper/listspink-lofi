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
import Dict
import Effect exposing (Effect)
import Event
import Json.Decode
import Lamdera
import Ports
import Route exposing (Route)
import Route.Path
import Set
import Shared.Model
import Shared.Msg
import SortedEventList
import Subscriptions
import Sync
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
    ( { adminData = { userManagement = UserManagement.init, backendSyncModel = Sync.initBackend, subscriptions = Subscriptions.init }
      , user = Nothing
      , syncCode = Nothing
      , nextIds = Nothing
      , syncModel = Sync.initFrontend
      , state = Event.initialState
      }
    , Effect.batch [ Effect.generateIds, Effect.loadUserData, Effect.loadFrontendSyncModel ]
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
        Shared.Msg.GotAdminData data ->
            ( { model | adminData = data }
            , Effect.none
            )

        Shared.Msg.NewUserCreated user ->
            ( { model | user = Just user }, Effect.batch [ Effect.storeUserData user, Effect.pushRoutePath Route.Path.Home_ ] )

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
                    Bridge.UserOnDevice { userId = data.userId, deviceId = data.deviceId, deviceName = data.deviceName, userName = data.name }
            in
            ( { model | user = Just user }, Effect.batch [ Effect.storeUserData user, Effect.pushRoutePath Route.Path.Home_ ] )

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



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.batch [ Ports.toElm Shared.Msg.GotMessageFromJs ]
