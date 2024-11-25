module Evergreen.V19.Main.Pages.Model exposing (..)

import Evergreen.V19.Pages.Account
import Evergreen.V19.Pages.Admin
import Evergreen.V19.Pages.Credits
import Evergreen.V19.Pages.Home_
import Evergreen.V19.Pages.List.ImportShared
import Evergreen.V19.Pages.Lists
import Evergreen.V19.Pages.Lists.Create
import Evergreen.V19.Pages.Lists.Edit.ListId_
import Evergreen.V19.Pages.Lists.Id_.CreateItem
import Evergreen.V19.Pages.Lists.ListId_
import Evergreen.V19.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V19.Pages.Manual
import Evergreen.V19.Pages.NotFound_
import Evergreen.V19.Pages.Settings
import Evergreen.V19.Pages.Setup
import Evergreen.V19.Pages.Setup.Connect
import Evergreen.V19.Pages.Setup.NewAccount
import Evergreen.V19.Pages.SetupKnown
import Evergreen.V19.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V19.Pages.Home_.Model
    | Account Evergreen.V19.Pages.Account.Model
    | Admin Evergreen.V19.Pages.Admin.Model
    | Credits Evergreen.V19.Pages.Credits.Model
    | List_ImportShared Evergreen.V19.Pages.List.ImportShared.Model
    | Lists Evergreen.V19.Pages.Lists.Model
    | Lists_Create Evergreen.V19.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V19.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V19.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V19.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V19.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V19.Pages.Manual.Model
    | Settings Evergreen.V19.Pages.Settings.Model
    | Setup Evergreen.V19.Pages.Setup.Model
    | Setup_Connect Evergreen.V19.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V19.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V19.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V19.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V19.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
