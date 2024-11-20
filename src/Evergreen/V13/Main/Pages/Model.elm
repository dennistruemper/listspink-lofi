module Evergreen.V13.Main.Pages.Model exposing (..)

import Evergreen.V13.Pages.Account
import Evergreen.V13.Pages.Admin
import Evergreen.V13.Pages.Credits
import Evergreen.V13.Pages.Home_
import Evergreen.V13.Pages.List.ImportShared
import Evergreen.V13.Pages.Lists
import Evergreen.V13.Pages.Lists.Create
import Evergreen.V13.Pages.Lists.Edit.ListId_
import Evergreen.V13.Pages.Lists.Id_.CreateItem
import Evergreen.V13.Pages.Lists.ListId_
import Evergreen.V13.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V13.Pages.Manual
import Evergreen.V13.Pages.NotFound_
import Evergreen.V13.Pages.Settings
import Evergreen.V13.Pages.Setup
import Evergreen.V13.Pages.Setup.Connect
import Evergreen.V13.Pages.Setup.NewAccount
import Evergreen.V13.Pages.SetupKnown
import Evergreen.V13.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V13.Pages.Home_.Model
    | Account Evergreen.V13.Pages.Account.Model
    | Admin Evergreen.V13.Pages.Admin.Model
    | Credits Evergreen.V13.Pages.Credits.Model
    | List_ImportShared Evergreen.V13.Pages.List.ImportShared.Model
    | Lists Evergreen.V13.Pages.Lists.Model
    | Lists_Create Evergreen.V13.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V13.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V13.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V13.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V13.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V13.Pages.Manual.Model
    | Settings Evergreen.V13.Pages.Settings.Model
    | Setup Evergreen.V13.Pages.Setup.Model
    | Setup_Connect Evergreen.V13.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V13.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V13.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V13.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V13.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
