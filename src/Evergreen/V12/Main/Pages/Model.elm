module Evergreen.V12.Main.Pages.Model exposing (..)

import Evergreen.V12.Pages.Account
import Evergreen.V12.Pages.Admin
import Evergreen.V12.Pages.Credits
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.List.ImportShared
import Evergreen.V12.Pages.Lists
import Evergreen.V12.Pages.Lists.Create
import Evergreen.V12.Pages.Lists.Edit.ListId_
import Evergreen.V12.Pages.Lists.Id_.CreateItem
import Evergreen.V12.Pages.Lists.ListId_
import Evergreen.V12.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V12.Pages.Manual
import Evergreen.V12.Pages.NotFound_
import Evergreen.V12.Pages.Settings
import Evergreen.V12.Pages.Setup
import Evergreen.V12.Pages.Setup.Connect
import Evergreen.V12.Pages.Setup.NewAccount
import Evergreen.V12.Pages.SetupKnown
import Evergreen.V12.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V12.Pages.Home_.Model
    | Account Evergreen.V12.Pages.Account.Model
    | Admin Evergreen.V12.Pages.Admin.Model
    | Credits Evergreen.V12.Pages.Credits.Model
    | List_ImportShared Evergreen.V12.Pages.List.ImportShared.Model
    | Lists Evergreen.V12.Pages.Lists.Model
    | Lists_Create Evergreen.V12.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V12.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V12.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V12.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V12.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V12.Pages.Manual.Model
    | Settings Evergreen.V12.Pages.Settings.Model
    | Setup Evergreen.V12.Pages.Setup.Model
    | Setup_Connect Evergreen.V12.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V12.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V12.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V12.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V12.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
