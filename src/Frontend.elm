module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Json.Encode
import Lamdera
import Main as ElmLand
import Main.Pages.Msg
import Pages.Admin.Users
import Pages.Home_
import Pages.Share.ListId_
import Shared.Msg
import Status
import Task
import Time
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
        SyncCodeCreated code ->
            ( model, sendSharedMsg <| Shared.Msg.GotSyncCode code )

        SyncCodeUsed userData ->
            ( model, sendSharedMsg <| Shared.Msg.GotUserData userData )

        ConnectionEstablished ->
            ( model, sendSharedMsg Shared.Msg.ConnectionEstablished )

        NotAuthenticated ->
            ( model, sendSharedMsg Shared.Msg.NotAuthenticated )

        EventSyncResult result ->
            ( model, sendSharedMsg <| Shared.Msg.GotSyncResult result )

        ListSubscriptionAdded data ->
            ElmLand.update (ElmLand.Page <| Main.Pages.Msg.Share_ListId_ <| Pages.Share.ListId_.GotListSubscriptionAdded data) model

        ListSubscriptionFailed ->
            ElmLand.update (ElmLand.Page <| Main.Pages.Msg.Share_ListId_ Pages.Share.ListId_.GotListSubscriptionFailed) model

        UserRolesUpdated data ->
            ( model, sendSharedMsg <| Shared.Msg.UserRolesUpdated data )

        AdminDataResponse response ->
            case response of
                UsersResponse users ->
                    -- do not user shared and send directly to requesting page
                    ElmLand.update (ElmLand.Page <| Main.Pages.Msg.Admin_Users <| Pages.Admin.Users.GotUsers users.users) model

                UserDeleted userId ->
                    let
                        ( newModel, updatePageCmd ) =
                            ElmLand.update (ElmLand.Page <| Main.Pages.Msg.Admin_Users (Pages.Admin.Users.UserDeleted userId)) model

                        statusResponseCmd =
                            sendSharedMsg <| Shared.Msg.StatusResponse (Status.Success (Just ("User deleted: " ++ userId))) userId
                    in
                    ( newModel, Cmd.batch [ updatePageCmd, statusResponseCmd ] )


sendSharedMsg : Shared.Msg.Msg -> Cmd FrontendMsg
sendSharedMsg msg =
    Time.now |> Task.perform (always (ElmLand.Shared msg))
