module Evergreen.V3.Route.Path exposing (..)


type Path
    = Home_
    | Account
    | Admin
    | Credits
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
    | Manual
    | Settings
    | Setup
    | Setup_Connect
    | Setup_NewAccount
    | SetupKnown
    | NotFound_
