module Route.Path exposing (Path(..), fromString, fromUrl, href, toString)

import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser exposing ((</>))


type Path
    = Home_
    | Account
    | Admin
    | Lists
    | Lists_Create
    | Lists_Id__CreateItem { id : String }
    | Lists_ListId_ { listId : String }
    | Manual
    | Settings
    | Setup
    | Setup_Connect
    | Setup_NewAccount
    | SetupKnown
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

        "admin" :: [] ->
            Just Admin

        "lists" :: [] ->
            Just Lists

        "lists" :: "create" :: [] ->
            Just Lists_Create

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

        "manual" :: [] ->
            Just Manual

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

                Admin ->
                    [ "admin" ]

                Lists ->
                    [ "lists" ]

                Lists_Create ->
                    [ "lists", "create" ]

                Lists_Id__CreateItem params ->
                    [ "lists", params.id, "create-item" ]

                Lists_ListId_ params ->
                    [ "lists", params.listId ]

                Manual ->
                    [ "manual" ]

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

                NotFound_ ->
                    [ "404" ]
    in
    pieces
        |> String.join "/"
        |> String.append "/"
