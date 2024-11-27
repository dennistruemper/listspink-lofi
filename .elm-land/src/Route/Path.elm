module Route.Path exposing (Path(..), fromString, fromUrl, href, toString)

import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser exposing ((</>))


type Path
    = Home_
    | Account
    | Admin_Manual
    | Admin_Menu
    | Admin_Users
    | Credits
    | List_ImportShared
    | Lists
    | Lists_Create
    | Lists_Edit_ListId_ { listId : String }
    | Lists_Id__CreateItem { id : String }
    | Lists_ListId_ { listId : String }
    | Lists_ListId__Edit_ItemId_ { listId : String, itemId : String }
    | Settings
    | Setup
    | Setup_Connect
    | Setup_NewAccount
    | SetupKnown
    | Share_ListId_ { listId : String }
    | NotFound_


fromUrl : Url -> Path
fromUrl url =
    fromString url.path
        |> Maybe.withDefault NotFound_


fromString : String -> Maybe Path
fromString urlPath =
    let
        urlPathSegments : List String
        urlPathSegments =
            urlPath
                |> String.split "/"
                |> List.filter (String.trim >> String.isEmpty >> Basics.not)
    in
    case urlPathSegments of
        [] ->
            Just Home_

        "account" :: [] ->
            Just Account

        "admin" :: "manual" :: [] ->
            Just Admin_Manual

        "admin" :: "menu" :: [] ->
            Just Admin_Menu

        "admin" :: "users" :: [] ->
            Just Admin_Users

        "credits" :: [] ->
            Just Credits

        "list" :: "import-shared" :: [] ->
            Just List_ImportShared

        "lists" :: [] ->
            Just Lists

        "lists" :: "create" :: [] ->
            Just Lists_Create

        "lists" :: "edit" :: listId_ :: [] ->
            Lists_Edit_ListId_
                { listId = listId_
                }
                |> Just

        "lists" :: id_ :: "create-item" :: [] ->
            Lists_Id__CreateItem
                { id = id_
                }
                |> Just

        "lists" :: listId_ :: [] ->
            Lists_ListId_
                { listId = listId_
                }
                |> Just

        "lists" :: listId_ :: "edit" :: itemId_ :: [] ->
            Lists_ListId__Edit_ItemId_
                { listId = listId_
                , itemId = itemId_
                }
                |> Just

        "settings" :: [] ->
            Just Settings

        "setup" :: [] ->
            Just Setup

        "setup" :: "connect" :: [] ->
            Just Setup_Connect

        "setup" :: "new-account" :: [] ->
            Just Setup_NewAccount

        "setup-known" :: [] ->
            Just SetupKnown

        "share" :: listId_ :: [] ->
            Share_ListId_
                { listId = listId_
                }
                |> Just

        _ ->
            Nothing


href : Path -> Html.Attribute msg
href path =
    Html.Attributes.href (toString path)


toString : Path -> String
toString path =
    let
        pieces : List String
        pieces =
            case path of
                Home_ ->
                    []

                Account ->
                    [ "account" ]

                Admin_Manual ->
                    [ "admin", "manual" ]

                Admin_Menu ->
                    [ "admin", "menu" ]

                Admin_Users ->
                    [ "admin", "users" ]

                Credits ->
                    [ "credits" ]

                List_ImportShared ->
                    [ "list", "import-shared" ]

                Lists ->
                    [ "lists" ]

                Lists_Create ->
                    [ "lists", "create" ]

                Lists_Edit_ListId_ params ->
                    [ "lists", "edit", params.listId ]

                Lists_Id__CreateItem params ->
                    [ "lists", params.id, "create-item" ]

                Lists_ListId_ params ->
                    [ "lists", params.listId ]

                Lists_ListId__Edit_ItemId_ params ->
                    [ "lists", params.listId, "edit", params.itemId ]

                Settings ->
                    [ "settings" ]

                Setup ->
                    [ "setup" ]

                Setup_Connect ->
                    [ "setup", "connect" ]

                Setup_NewAccount ->
                    [ "setup", "new-account" ]

                SetupKnown ->
                    [ "setup-known" ]

                Share_ListId_ params ->
                    [ "share", params.listId ]

                NotFound_ ->
                    [ "404" ]
    in
    pieces
        |> String.join "/"
        |> String.append "/"
