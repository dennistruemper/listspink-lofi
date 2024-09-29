module Evergreen.V7.Main.Pages.Model exposing (..)

import Evergreen.V7.Pages.Account
import Evergreen.V7.Pages.Admin
import Evergreen.V7.Pages.Credits
import Evergreen.V7.Pages.Home_
import Evergreen.V7.Pages.Lists
import Evergreen.V7.Pages.Lists.Create
import Evergreen.V7.Pages.Lists.Edit.ListId_
import Evergreen.V7.Pages.Lists.Id_.CreateItem
import Evergreen.V7.Pages.Lists.ListId_
import Evergreen.V7.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V7.Pages.Manual
import Evergreen.V7.Pages.NotFound_
import Evergreen.V7.Pages.Settings
import Evergreen.V7.Pages.Setup
import Evergreen.V7.Pages.Setup.Connect
import Evergreen.V7.Pages.Setup.NewAccount
import Evergreen.V7.Pages.SetupKnown


type Model
    = Home_ Evergreen.V7.Pages.Home_.Model
    | Account Evergreen.V7.Pages.Account.Model
    | Admin Evergreen.V7.Pages.Admin.Model
    | Credits Evergreen.V7.Pages.Credits.Model
    | Lists Evergreen.V7.Pages.Lists.Model
    | Lists_Create Evergreen.V7.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V7.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V7.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V7.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V7.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V7.Pages.Manual.Model
    | Settings Evergreen.V7.Pages.Settings.Model
    | Setup Evergreen.V7.Pages.Setup.Model
    | Setup_Connect Evergreen.V7.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V7.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V7.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V7.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
