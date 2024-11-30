module Pages.Admin.Users exposing (Model, Msg(..), page)

import Auth
import Bridge
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Lamdera
import Layouts
import Page exposing (Page)
import Role
import Route exposing (Route)
import Set exposing (Set)
import Shared
import View exposing (View)


title =
    "Admin Users"


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page user shared route =
    Page.new
        { init = init user
        , update = update
        , subscriptions = subscriptions
        , view = view user shared
        }
        |> Page.withLayout (toLayout user)


toLayout : Auth.User -> Model -> Layouts.Layout Msg
toLayout user model =
    Layouts.Scaffold { caption = Just title }



-- INIT


type alias Model =
    { loadedUsers : Maybe (List Bridge.UserData)
    , expandedUsers : Set String
    , searchQuery : String
    , userToDelete : Maybe String
    }


init : Auth.User -> () -> ( Model, Effect Msg )
init user () =
    let
        redirectEffect =
            Auth.redirectIfNotAdmin user

        requestAdminDataEffect =
            Auth.ifAdminElse user
                (Effect.sendCmd <| Lamdera.sendToBackend (Bridge.AdminRequest Bridge.UsersRequest))
                Effect.none
    in
    ( { loadedUsers = Nothing, expandedUsers = Set.empty, searchQuery = "", userToDelete = Nothing }
    , Effect.batch [ redirectEffect, requestAdminDataEffect ]
    )



-- UPDATE


type Msg
    = NoOp
    | ToggleUserDetails String
    | RequestAdminData
    | GotUsers (List Bridge.UserData)
    | UpdateSearchQuery String
    | DeleteUserClicked String
    | UserDeleted String
    | ConfirmDelete String
    | CancelDelete
    | ConfirmDeleteUser String


toggleSetValue : String -> Set String -> Set String
toggleSetValue value set =
    if Set.member value set then
        Set.remove value set

    else
        Set.insert value set


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )

        ToggleUserDetails userId ->
            ( { model | expandedUsers = toggleSetValue userId model.expandedUsers }, Effect.none )

        RequestAdminData ->
            ( model
            , Effect.sendCmd <| Lamdera.sendToBackend (Bridge.AdminRequest Bridge.UsersRequest)
            )

        GotUsers users ->
            ( { model | loadedUsers = Just users }, Effect.none )

        UpdateSearchQuery query ->
            ( { model | searchQuery = query }
            , Effect.none
            )

        DeleteUserClicked userId ->
            ( model
            , Effect.sendCmd <| Lamdera.sendToBackend (Bridge.AdminRequest (Bridge.DeleteUser userId))
            )

        UserDeleted userId ->
            let
                newLoadedUsers =
                    model.loadedUsers |> Maybe.map (List.filter (\user -> user.userId /= userId))
            in
            ( { model | loadedUsers = newLoadedUsers }, Effect.none )

        ConfirmDelete userId ->
            ( { model | userToDelete = Just userId }, Effect.none )

        CancelDelete ->
            ( { model | userToDelete = Nothing }, Effect.none )

        ConfirmDeleteUser userId ->
            ( { model | userToDelete = Nothing }, Effect.sendCmd <| Lamdera.sendToBackend (Bridge.AdminRequest (Bridge.DeleteUser userId)) )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Auth.User -> Shared.Model -> Model -> View Msg
view user shared model =
    { title = title
    , body =
        Auth.ifAdminElse user
            [ viewUsersContainer model shared ]
            [ Html.text "Not allowed" ]
    }


viewUsersContainer : Model -> Shared.Model -> Html Msg
viewUsersContainer model shared =
    Html.div
        [ Attr.class "p-6 max-w-7xl mx-auto" ]
        [ Html.h1
            [ Attr.class "text-3xl font-bold mb-6 text-gray-800" ]
            [ Html.text "User Management" ]
        , viewSearchBar model
        , Html.div
            [ Attr.class "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" ]
            (case model.loadedUsers of
                Just users ->
                    let
                        filteredUsers =
                            filterUsers model.searchQuery users
                    in
                    if List.isEmpty filteredUsers then
                        [ viewNoResults model.searchQuery ]

                    else
                        List.map (viewUserCard model) filteredUsers

                _ ->
                    [ Html.div [ Attr.class "text-gray-600" ] [ Html.text "Loading users..." ] ]
            )
        , case model.userToDelete of
            Just userId ->
                viewConfirmationDialog userId

            Nothing ->
                Html.text ""
        ]


viewSearchBar : Model -> Html Msg
viewSearchBar model =
    Html.div
        [ Attr.class """
            relative w-full max-w-md mx-auto mb-6
          """
        ]
        [ Html.div
            [ Attr.class """
                absolute inset-y-0 left-0 pl-3 flex items-center
                pointer-events-none text-gray-400
              """
            ]
            [ Html.i
                [ Attr.class "fas fa-search" ]
                []
            ]
        , Html.input
            [ Attr.type_ "text"
            , Attr.placeholder "Search users or devices..."
            , Attr.value model.searchQuery
            , Events.onInput UpdateSearchQuery
            , Attr.class """
                w-full pl-10 pr-4 py-2 rounded-lg
                border border-gray-300 focus:border-purple-500
                focus:ring-2 focus:ring-purple-200
                transition-colors duration-200
                placeholder-gray-400
              """
            ]
            []
        , if not (String.isEmpty model.searchQuery) then
            Html.button
                [ Attr.class """
                    absolute inset-y-0 right-0 pr-3 flex items-center
                    text-gray-400 hover:text-gray-600
                  """
                , Events.onClick (UpdateSearchQuery "")
                ]
                [ Html.i
                    [ Attr.class "fas fa-times" ]
                    []
                ]

          else
            Html.text ""
        ]


viewUserCard : Model -> Bridge.UserData -> Html Msg
viewUserCard model userData =
    let
        isExpanded =
            Set.member userData.userId model.expandedUsers

        expandClass =
            if isExpanded then
                "h-auto"

            else
                "h-48"
    in
    Html.div
        [ Attr.class """
            relative bg-white rounded-lg shadow-md overflow-hidden
            transition-all duration-300 ease-in-out
            hover:shadow-lg
        """
        , Attr.class expandClass
        ]
        [ Html.div
            [ Attr.class "p-6" ]
            [ -- Header
              Html.div
                [ Attr.class "flex justify-between items-start mb-4" ]
                [ Html.h2
                    [ Attr.class "text-xl font-semibold text-gray-800" ]
                    [ Html.text userData.name ]
                , Html.button
                    [ Attr.class """
                        p-2 rounded-full hover:bg-gray-100
                        transition-colors duration-200
                      """
                    , Events.onClick (ToggleUserDetails userData.userId)
                    ]
                    [ Html.text
                        (if isExpanded then
                            "▼"

                         else
                            "▶"
                        )
                    ]
                , Html.button
                    [ Attr.class """
                            p-2 text-red-600 hover:bg-red-50 rounded-full
                            transition-colors duration-200
                          """
                    , Events.onClick (ConfirmDelete userData.userId)
                    ]
                    [ Html.text "🗑" ]
                ]

            -- User ID
            , Html.div
                [ Attr.class "text-sm text-gray-600 mb-4" ]
                [ Html.text ("ID: " ++ userData.userId) ]

            -- Devices Section
            , Html.div
                [ Attr.class "space-y-3" ]
                [ Html.h3
                    [ Attr.class "text-md font-medium text-gray-700" ]
                    [ Html.text "Devices" ]
                , Html.div
                    [ Attr.class "space-y-2" ]
                    (List.map viewDeviceEntry userData.devices)
                ]
            ]

        -- Gradient overlay for collapsed cards
        , if not isExpanded then
            Html.div
                [ Attr.class """
                    absolute bottom-0 left-0 right-0 h-24
                    bg-linear-to-t from-white to-transparent
                  """
                ]
                []

          else
            Html.text ""
        ]


viewDeviceEntry : { deviceId : String, name : String } -> Html Msg
viewDeviceEntry device =
    Html.div
        [ Attr.class """
            bg-gray-50 rounded-md p-3
            border border-gray-200
          """
        ]
        [ Html.div
            [ Attr.class "font-medium text-gray-700" ]
            [ Html.text device.name ]
        , Html.div
            [ Attr.class "text-sm text-gray-500" ]
            [ Html.text ("Device ID: " ++ device.deviceId) ]
        ]


containsIgnoreCase : String -> String -> Bool
containsIgnoreCase query value =
    String.contains (String.toLower query) (String.toLower value)


filterUsers : String -> List Bridge.UserData -> List Bridge.UserData
filterUsers query users =
    if String.isEmpty (String.trim query) then
        users

    else
        let
            matches user =
                let
                    deviceMatches =
                        List.any
                            (\device ->
                                containsIgnoreCase query device.name
                            )
                            user.devices
                in
                containsIgnoreCase query user.name || deviceMatches
        in
        List.filter matches users


viewNoResults : String -> Html Msg
viewNoResults query =
    Html.div
        [ Attr.class """
            col-span-full py-12 text-center
            text-gray-500
          """
        ]
        [ Html.i
            [ Attr.class "fas fa-search mb-4 text-4xl" ]
            []
        , Html.div
            [ Attr.class "text-lg" ]
            [ Html.text "No users or devices found matching query"
            ]
        , Html.button
            [ Attr.class """
                mt-4 text-purple-600 hover:text-purple-700
                underline focus:outline-hidden
              """
            , Events.onClick (UpdateSearchQuery "")
            ]
            [ Html.text "Clear search" ]
        ]


viewConfirmationDialog : String -> Html Msg
viewConfirmationDialog userId =
    Html.div
        [ Attr.class "fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" ]
        [ Html.div
            [ Attr.class "bg-white p-6 rounded-lg shadow-xl" ]
            [ Html.h3
                [ Attr.class "text-lg font-bold mb-4" ]
                [ Html.text "Confirm Deletion" ]
            , Html.p
                [ Attr.class "mb-6" ]
                [ Html.text "Are you sure you want to delete this user?" ]
            , Html.div
                [ Attr.class "flex justify-end space-x-4" ]
                [ Html.button
                    [ Attr.class "px-4 py-2 text-gray-600 hover:bg-gray-100 rounded-sm"
                    , Events.onClick CancelDelete
                    ]
                    [ Html.text "Cancel" ]
                , Html.button
                    [ Attr.class "px-4 py-2 bg-red-600 text-white hover:bg-red-700 rounded-sm"
                    , Events.onClick (ConfirmDeleteUser userId)
                    ]
                    [ Html.text "Delete" ]
                ]
            ]
        ]
