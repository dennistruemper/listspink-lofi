module Evergreen.V15.Main.Pages.Model exposing (..)

import Evergreen.V15.Pages.Account
import Evergreen.V15.Pages.Admin
import Evergreen.V15.Pages.Credits
import Evergreen.V15.Pages.Home_
import Evergreen.V15.Pages.List.ImportShared
import Evergreen.V15.Pages.Lists
import Evergreen.V15.Pages.Lists.Create
import Evergreen.V15.Pages.Lists.Edit.ListId_
import Evergreen.V15.Pages.Lists.Id_.CreateItem
import Evergreen.V15.Pages.Lists.ListId_
import Evergreen.V15.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V15.Pages.Manual
import Evergreen.V15.Pages.NotFound_
import Evergreen.V15.Pages.Settings
import Evergreen.V15.Pages.Setup
import Evergreen.V15.Pages.Setup.Connect
import Evergreen.V15.Pages.Setup.NewAccount
import Evergreen.V15.Pages.SetupKnown
import Evergreen.V15.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V15.Pages.Home_.Model
    | Account Evergreen.V15.Pages.Account.Model
    | Admin Evergreen.V15.Pages.Admin.Model
    | Credits Evergreen.V15.Pages.Credits.Model
    | List_ImportShared Evergreen.V15.Pages.List.ImportShared.Model
    | Lists Evergreen.V15.Pages.Lists.Model
    | Lists_Create Evergreen.V15.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V15.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V15.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V15.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V15.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V15.Pages.Manual.Model
    | Settings Evergreen.V15.Pages.Settings.Model
    | Setup Evergreen.V15.Pages.Setup.Model
    | Setup_Connect Evergreen.V15.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V15.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V15.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V15.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V15.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
