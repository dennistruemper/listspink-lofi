module Evergreen.V1.Main.Pages.Model exposing (..)

import Evergreen.V1.Pages.Account
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Credits
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Lists
import Evergreen.V1.Pages.Lists.Create
import Evergreen.V1.Pages.Lists.Edit.ListId_
import Evergreen.V1.Pages.Lists.Id_.CreateItem
import Evergreen.V1.Pages.Lists.ListId_
import Evergreen.V1.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V1.Pages.Manual
import Evergreen.V1.Pages.NotFound_
import Evergreen.V1.Pages.Settings
import Evergreen.V1.Pages.Setup
import Evergreen.V1.Pages.Setup.Connect
import Evergreen.V1.Pages.Setup.NewAccount
import Evergreen.V1.Pages.SetupKnown


type Model
    = Home_ Evergreen.V1.Pages.Home_.Model
    | Account Evergreen.V1.Pages.Account.Model
    | Admin Evergreen.V1.Pages.Admin.Model
    | Credits Evergreen.V1.Pages.Credits.Model
    | Lists Evergreen.V1.Pages.Lists.Model
    | Lists_Create Evergreen.V1.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V1.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V1.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V1.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V1.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V1.Pages.Manual.Model
    | Settings Evergreen.V1.Pages.Settings.Model
    | Setup Evergreen.V1.Pages.Setup.Model
    | Setup_Connect Evergreen.V1.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V1.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V1.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V1.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
