module Evergreen.V4.Main.Pages.Model exposing (..)

import Evergreen.V4.Pages.Account
import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.Credits
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Lists
import Evergreen.V4.Pages.Lists.Create
import Evergreen.V4.Pages.Lists.Edit.ListId_
import Evergreen.V4.Pages.Lists.Id_.CreateItem
import Evergreen.V4.Pages.Lists.ListId_
import Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V4.Pages.Manual
import Evergreen.V4.Pages.NotFound_
import Evergreen.V4.Pages.Settings
import Evergreen.V4.Pages.Setup
import Evergreen.V4.Pages.Setup.Connect
import Evergreen.V4.Pages.Setup.NewAccount
import Evergreen.V4.Pages.SetupKnown


type Model
    = Home_ Evergreen.V4.Pages.Home_.Model
    | Account Evergreen.V4.Pages.Account.Model
    | Admin Evergreen.V4.Pages.Admin.Model
    | Credits Evergreen.V4.Pages.Credits.Model
    | Lists Evergreen.V4.Pages.Lists.Model
    | Lists_Create Evergreen.V4.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V4.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V4.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V4.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V4.Pages.Manual.Model
    | Settings Evergreen.V4.Pages.Settings.Model
    | Setup Evergreen.V4.Pages.Setup.Model
    | Setup_Connect Evergreen.V4.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V4.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V4.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V4.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
