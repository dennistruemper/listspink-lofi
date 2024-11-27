module Evergreen.V20.Main.Pages.Model exposing (..)

import Evergreen.V20.Pages.Account
import Evergreen.V20.Pages.Admin.Manual
import Evergreen.V20.Pages.Admin.Menu
import Evergreen.V20.Pages.Admin.Users
import Evergreen.V20.Pages.Credits
import Evergreen.V20.Pages.Home_
import Evergreen.V20.Pages.List.ImportShared
import Evergreen.V20.Pages.Lists
import Evergreen.V20.Pages.Lists.Create
import Evergreen.V20.Pages.Lists.Edit.ListId_
import Evergreen.V20.Pages.Lists.Id_.CreateItem
import Evergreen.V20.Pages.Lists.ListId_
import Evergreen.V20.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V20.Pages.NotFound_
import Evergreen.V20.Pages.Settings
import Evergreen.V20.Pages.Setup
import Evergreen.V20.Pages.Setup.Connect
import Evergreen.V20.Pages.Setup.NewAccount
import Evergreen.V20.Pages.SetupKnown
import Evergreen.V20.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V20.Pages.Home_.Model
    | Account Evergreen.V20.Pages.Account.Model
    | Admin_Manual Evergreen.V20.Pages.Admin.Manual.Model
    | Admin_Menu Evergreen.V20.Pages.Admin.Menu.Model
    | Admin_Users Evergreen.V20.Pages.Admin.Users.Model
    | Credits Evergreen.V20.Pages.Credits.Model
    | List_ImportShared Evergreen.V20.Pages.List.ImportShared.Model
    | Lists Evergreen.V20.Pages.Lists.Model
    | Lists_Create Evergreen.V20.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V20.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V20.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V20.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V20.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Settings Evergreen.V20.Pages.Settings.Model
    | Setup Evergreen.V20.Pages.Setup.Model
    | Setup_Connect Evergreen.V20.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V20.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V20.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V20.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V20.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
