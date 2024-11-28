module Evergreen.V21.Main.Pages.Model exposing (..)

import Evergreen.V21.Pages.Account
import Evergreen.V21.Pages.Admin.Manual
import Evergreen.V21.Pages.Admin.Menu
import Evergreen.V21.Pages.Admin.Users
import Evergreen.V21.Pages.Credits
import Evergreen.V21.Pages.Home_
import Evergreen.V21.Pages.List.ImportShared
import Evergreen.V21.Pages.Lists
import Evergreen.V21.Pages.Lists.Create
import Evergreen.V21.Pages.Lists.Edit.ListId_
import Evergreen.V21.Pages.Lists.Id_.CreateItem
import Evergreen.V21.Pages.Lists.ListId_
import Evergreen.V21.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V21.Pages.NotFound_
import Evergreen.V21.Pages.Settings
import Evergreen.V21.Pages.Setup
import Evergreen.V21.Pages.Setup.Connect
import Evergreen.V21.Pages.Setup.NewAccount
import Evergreen.V21.Pages.SetupKnown
import Evergreen.V21.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V21.Pages.Home_.Model
    | Account Evergreen.V21.Pages.Account.Model
    | Admin_Manual Evergreen.V21.Pages.Admin.Manual.Model
    | Admin_Menu Evergreen.V21.Pages.Admin.Menu.Model
    | Admin_Users Evergreen.V21.Pages.Admin.Users.Model
    | Credits Evergreen.V21.Pages.Credits.Model
    | List_ImportShared Evergreen.V21.Pages.List.ImportShared.Model
    | Lists Evergreen.V21.Pages.Lists.Model
    | Lists_Create Evergreen.V21.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V21.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V21.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V21.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V21.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Settings Evergreen.V21.Pages.Settings.Model
    | Setup Evergreen.V21.Pages.Setup.Model
    | Setup_Connect Evergreen.V21.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V21.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V21.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V21.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V21.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
