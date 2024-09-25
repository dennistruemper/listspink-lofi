module Evergreen.V2.Main.Pages.Model exposing (..)

import Evergreen.V2.Pages.Account
import Evergreen.V2.Pages.Admin
import Evergreen.V2.Pages.Credits
import Evergreen.V2.Pages.Home_
import Evergreen.V2.Pages.Lists
import Evergreen.V2.Pages.Lists.Create
import Evergreen.V2.Pages.Lists.Edit.ListId_
import Evergreen.V2.Pages.Lists.Id_.CreateItem
import Evergreen.V2.Pages.Lists.ListId_
import Evergreen.V2.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V2.Pages.Manual
import Evergreen.V2.Pages.NotFound_
import Evergreen.V2.Pages.Settings
import Evergreen.V2.Pages.Setup
import Evergreen.V2.Pages.Setup.Connect
import Evergreen.V2.Pages.Setup.NewAccount
import Evergreen.V2.Pages.SetupKnown


type Model
    = Home_ Evergreen.V2.Pages.Home_.Model
    | Account Evergreen.V2.Pages.Account.Model
    | Admin Evergreen.V2.Pages.Admin.Model
    | Credits Evergreen.V2.Pages.Credits.Model
    | Lists Evergreen.V2.Pages.Lists.Model
    | Lists_Create Evergreen.V2.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V2.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V2.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V2.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V2.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V2.Pages.Manual.Model
    | Settings Evergreen.V2.Pages.Settings.Model
    | Setup Evergreen.V2.Pages.Setup.Model
    | Setup_Connect Evergreen.V2.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V2.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V2.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V2.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
