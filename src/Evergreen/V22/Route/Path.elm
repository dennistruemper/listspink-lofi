module Evergreen.V22.Route.Path exposing (..)


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
    | Lists_Edit_ListId_
        { listId : String
        }
    | Lists_Id__CreateItem
        { id : String
        }
    | Lists_ListId_
        { listId : String
        }
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
    | Settings
    | Setup
    | Setup_Connect
    | Setup_NewAccount
    | SetupKnown
    | Share_ListId_
        { listId : String
        }
    | NotFound_
