module Effect exposing
    ( Effect
    , accountCreated
    , addEvent
    , addToast
    , back
    , batch
    , copyToClipboard
    , generateIds
    , getTime
    , loadExternalUrl
    , loadFrontendSyncModel
    , loadUserData
    , loadVersion
    , log
    , logout
    , map
    , none
    , pushRoute
    , pushRoutePath
    , removeToast
    , replaceRoute
    , replaceRoutePath
    , sendCmd
    , sendMsg
    , storeFrontendSyncModel
    , storeUserData
    , toCmd
    , toggleSidebar
    )

import Bridge
import Browser.Navigation
import Components.Toast
import Dict exposing (Dict)
import Event exposing (EventDefinition)
import FrontendSyncModelSerializer
import Json.Encode
import Ports
import Process
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg
import Sync
import Task
import Time
import Url exposing (Url)


type Effect msg
    = -- BASICS
      None
    | Batch (List (Effect msg))
    | SendCmd (Cmd msg)
      -- ROUTING
    | PushUrl String
    | ReplaceUrl String
    | LoadExternalUrl String
    | Back
      -- SHARED
    | SendSharedMsg Shared.Msg.Msg
    | SendMessageToJavaScript
        { tag : String
        , data : Json.Encode.Value
        }



-- CUSTOM


log : String -> Effect msg
log message =
    SendMessageToJavaScript
        { tag = "Log"
        , data = Json.Encode.string message
        }


copyToClipboard : String -> Effect msg
copyToClipboard text =
    SendMessageToJavaScript
        { tag = "CopyToClipboard"
        , data = Json.Encode.string text
        }


generateIds : Effect msg
generateIds =
    SendMessageToJavaScript
        { tag = "GenerateIds"
        , data = Json.Encode.object []
        }


storeUserData : Bridge.User -> Effect msg
storeUserData user =
    SendMessageToJavaScript
        { tag = "StoreUserData"
        , data = Bridge.encodeUser user
        }


loadUserData : Effect msg
loadUserData =
    SendMessageToJavaScript
        { tag = "LoadUserData"
        , data = Json.Encode.null
        }


loadVersion : Effect msg
loadVersion =
    SendMessageToJavaScript
        { tag = "LoadVersion"
        , data = Json.Encode.null
        }


storeFrontendSyncModel : Sync.FrontendSyncModel -> Effect msg
storeFrontendSyncModel model =
    SendMessageToJavaScript
        { tag = "StoreFrontendSyncModel"
        , data = Json.Encode.string (FrontendSyncModelSerializer.serializeFrontendSyncModel model)
        }


loadFrontendSyncModel : Effect msg
loadFrontendSyncModel =
    SendMessageToJavaScript
        { tag = "LoadFrontendSyncModel"
        , data = Json.Encode.null
        }


logout : Effect msg
logout =
    SendMessageToJavaScript
        { tag = "Logout"
        , data = Json.Encode.null
        }


accountCreated : Bridge.User -> Effect msg
accountCreated user =
    batch [ SendSharedMsg (Shared.Msg.NewUserCreated user), generateIds ]


addEvent : EventDefinition -> Effect msg
addEvent event =
    SendSharedMsg (Shared.Msg.AddEvent event)


toggleSidebar : Bool -> Effect msg
toggleSidebar open =
    SendSharedMsg (Shared.Msg.SidebarToggled open)


getTime : (Time.Posix -> msg) -> Effect msg
getTime gotTimeMsg =
    SendCmd (Time.now |> Task.perform gotTimeMsg)


addToast : Components.Toast.Toast -> Effect msg
addToast toastInput =
    SendSharedMsg (Shared.Msg.AddToast toastInput)


removeToast : Int -> Effect msg
removeToast id =
    SendSharedMsg (Shared.Msg.ToastMsg (Components.Toast.RemoveToast id))



--]
--]
-- BASICS


{-| Don't send any effect.
-}
none : Effect msg
none =
    None


{-| Send multiple effects at once.
-}
batch : List (Effect msg) -> Effect msg
batch =
    Batch


{-| Send a normal `Cmd msg` as an effect, something like `Http.get` or `Random.generate`.
-}
sendCmd : Cmd msg -> Effect msg
sendCmd =
    SendCmd


{-| Send a message as an effect. Useful when emitting events from UI components.
-}
sendMsg : msg -> Effect msg
sendMsg msg =
    Task.succeed msg
        |> Task.perform identity
        |> SendCmd



-- ROUTING


{-| Set the new route, and make the back button go back to the current route.
-}
pushRoute :
    { path : Route.Path.Path
    , query : Dict String String
    , hash : Maybe String
    }
    -> Effect msg
pushRoute route =
    PushUrl (Route.toString route)


{-| Same as `Effect.pushRoute`, but without `query` or `hash` support
-}
pushRoutePath : Route.Path.Path -> Effect msg
pushRoutePath path =
    batch [ PushUrl (Route.Path.toString path), toggleSidebar False ]


{-| Set the new route, but replace the previous one, so clicking the back
button **won't** go back to the previous route.
-}
replaceRoute :
    { path : Route.Path.Path
    , query : Dict String String
    , hash : Maybe String
    }
    -> Effect msg
replaceRoute route =
    ReplaceUrl (Route.toString route)


{-| Same as `Effect.replaceRoute`, but without `query` or `hash` support
-}
replaceRoutePath : Route.Path.Path -> Effect msg
replaceRoutePath path =
    ReplaceUrl (Route.Path.toString path)


{-| Redirect users to a new URL, somewhere external to your web application.
-}
loadExternalUrl : String -> Effect msg
loadExternalUrl =
    LoadExternalUrl


{-| Navigate back one page
-}
back : Effect msg
back =
    Back



-- INTERNALS


{-| Elm Land depends on this function to connect pages and layouts
together into the overall app.
-}
map : (msg1 -> msg2) -> Effect msg1 -> Effect msg2
map fn effect =
    case effect of
        None ->
            None

        Batch list ->
            Batch (List.map (map fn) list)

        SendCmd cmd ->
            SendCmd (Cmd.map fn cmd)

        PushUrl url ->
            PushUrl url

        ReplaceUrl url ->
            ReplaceUrl url

        Back ->
            Back

        LoadExternalUrl url ->
            LoadExternalUrl url

        SendSharedMsg sharedMsg ->
            SendSharedMsg sharedMsg

        SendMessageToJavaScript message ->
            SendMessageToJavaScript message


{-| Elm Land depends on this function to perform your effects.
-}
toCmd :
    { key : Browser.Navigation.Key
    , url : Url
    , shared : Shared.Model.Model
    , fromSharedMsg : Shared.Msg.Msg -> msg
    , batch : List msg -> msg
    , toCmd : msg -> Cmd msg
    }
    -> Effect msg
    -> Cmd msg
toCmd options effect =
    case effect of
        None ->
            Cmd.none

        Batch list ->
            Cmd.batch (List.map (toCmd options) list)

        SendCmd cmd ->
            cmd

        PushUrl url ->
            Browser.Navigation.pushUrl options.key url

        ReplaceUrl url ->
            Browser.Navigation.replaceUrl options.key url

        Back ->
            Browser.Navigation.back options.key 1

        LoadExternalUrl url ->
            Browser.Navigation.load url

        SendSharedMsg sharedMsg ->
            Task.succeed sharedMsg
                |> Task.perform options.fromSharedMsg

        SendMessageToJavaScript message ->
            Ports.toJs message
