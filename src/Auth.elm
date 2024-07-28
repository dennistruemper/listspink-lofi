module Auth exposing (User, onPageLoad, viewCustomPage)

import Auth.Action
import Bridge
import Dict
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
