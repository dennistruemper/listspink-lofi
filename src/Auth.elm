module Auth exposing (User, ifAdminElse, onPageLoad, redirectIfNotAdmin, viewCustomPage)

import Auth.Action
import Bridge
import Components.Toast
import Dict
import Effect
import Role
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias User =
    Bridge.User


{-| Called before an auth-only page is loaded.
-}
onPageLoad : Shared.Model -> Route () -> Auth.Action.Action User
onPageLoad shared route =
    case shared.user of
        Just user ->
            case user of
                Bridge.Unknown ->
                    redirectToSetupPage route

                Bridge.UserOnDevice _ ->
                    Auth.Action.loadPageWithUser user

        Nothing ->
            redirectToSetupPage route


redirectToSetupPage : Route () -> Auth.Action.Action User
redirectToSetupPage route =
    Auth.Action.pushRoute
        { path = Route.Path.Setup
        , query =
            Dict.fromList
                [ ( "from", route.url.path ) ]
        , hash = Nothing
        }


{-| Renders whenever `Auth.Action.loadCustomPage` is returned from `onPageLoad`.
-}
viewCustomPage : Shared.Model -> Route () -> View Never
viewCustomPage shared route =
    View.fromString "Loading..."


ifAdminElse : Bridge.User -> a -> a -> a
ifAdminElse user onAllowed onDisallowed =
    case user of
        Bridge.UserOnDevice userData ->
            if userData.roles |> List.member Role.Admin then
                onAllowed

            else
                onDisallowed

        Bridge.Unknown ->
            onDisallowed


redirectIfNotAdmin user =
    ifAdminElse user Effect.none (Effect.batch [ Effect.replaceRoutePath Route.Path.Home_, Effect.addToast (Components.Toast.error "You are not authorized to access this page.") ])
