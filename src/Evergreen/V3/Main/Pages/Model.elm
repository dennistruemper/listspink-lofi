module Evergreen.V3.Main.Pages.Model exposing (..)

import Evergreen.V3.Pages.Account
import Evergreen.V3.Pages.Admin
import Evergreen.V3.Pages.Credits
import Evergreen.V3.Pages.Home_
import Evergreen.V3.Pages.Lists
import Evergreen.V3.Pages.Lists.Create
import Evergreen.V3.Pages.Lists.Edit.ListId_
import Evergreen.V3.Pages.Lists.Id_.CreateItem
import Evergreen.V3.Pages.Lists.ListId_
import Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V3.Pages.Manual
import Evergreen.V3.Pages.NotFound_
import Evergreen.V3.Pages.Settings
import Evergreen.V3.Pages.Setup
import Evergreen.V3.Pages.Setup.Connect
import Evergreen.V3.Pages.Setup.NewAccount
import Evergreen.V3.Pages.SetupKnown


type Model
    = Home_ Evergreen.V3.Pages.Home_.Model
    | Account Evergreen.V3.Pages.Account.Model
    | Admin Evergreen.V3.Pages.Admin.Model
    | Credits Evergreen.V3.Pages.Credits.Model
    | Lists Evergreen.V3.Pages.Lists.Model
    | Lists_Create Evergreen.V3.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V3.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V3.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V3.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V3.Pages.Manual.Model
    | Settings Evergreen.V3.Pages.Settings.Model
    | Setup Evergreen.V3.Pages.Setup.Model
    | Setup_Connect Evergreen.V3.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V3.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V3.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V3.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
