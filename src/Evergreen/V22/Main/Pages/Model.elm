module Evergreen.V22.Main.Pages.Model exposing (..)

import Evergreen.V22.Pages.Account
import Evergreen.V22.Pages.Admin.Manual
import Evergreen.V22.Pages.Admin.Menu
import Evergreen.V22.Pages.Admin.Users
import Evergreen.V22.Pages.Credits
import Evergreen.V22.Pages.Home_
import Evergreen.V22.Pages.List.ImportShared
import Evergreen.V22.Pages.Lists
import Evergreen.V22.Pages.Lists.Create
import Evergreen.V22.Pages.Lists.Edit.ListId_
import Evergreen.V22.Pages.Lists.Id_.CreateItem
import Evergreen.V22.Pages.Lists.ListId_
import Evergreen.V22.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V22.Pages.NotFound_
import Evergreen.V22.Pages.Settings
import Evergreen.V22.Pages.Setup
import Evergreen.V22.Pages.Setup.Connect
import Evergreen.V22.Pages.Setup.NewAccount
import Evergreen.V22.Pages.SetupKnown
import Evergreen.V22.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V22.Pages.Home_.Model
    | Account Evergreen.V22.Pages.Account.Model
    | Admin_Manual Evergreen.V22.Pages.Admin.Manual.Model
    | Admin_Menu Evergreen.V22.Pages.Admin.Menu.Model
    | Admin_Users Evergreen.V22.Pages.Admin.Users.Model
    | Credits Evergreen.V22.Pages.Credits.Model
    | List_ImportShared Evergreen.V22.Pages.List.ImportShared.Model
    | Lists Evergreen.V22.Pages.Lists.Model
    | Lists_Create Evergreen.V22.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V22.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V22.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V22.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V22.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Settings Evergreen.V22.Pages.Settings.Model
    | Setup Evergreen.V22.Pages.Setup.Model
    | Setup_Connect Evergreen.V22.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V22.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V22.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V22.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V22.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
