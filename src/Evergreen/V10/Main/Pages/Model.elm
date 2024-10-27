module Evergreen.V10.Main.Pages.Model exposing (..)

import Evergreen.V10.Pages.Account
import Evergreen.V10.Pages.Admin
import Evergreen.V10.Pages.Credits
import Evergreen.V10.Pages.Home_
import Evergreen.V10.Pages.Lists
import Evergreen.V10.Pages.Lists.Create
import Evergreen.V10.Pages.Lists.Edit.ListId_
import Evergreen.V10.Pages.Lists.Id_.CreateItem
import Evergreen.V10.Pages.Lists.ListId_
import Evergreen.V10.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V10.Pages.Manual
import Evergreen.V10.Pages.NotFound_
import Evergreen.V10.Pages.Settings
import Evergreen.V10.Pages.Setup
import Evergreen.V10.Pages.Setup.Connect
import Evergreen.V10.Pages.Setup.NewAccount
import Evergreen.V10.Pages.SetupKnown
import Evergreen.V10.Pages.Share.ListId_


type Model
    = Home_ Evergreen.V10.Pages.Home_.Model
    | Account Evergreen.V10.Pages.Account.Model
    | Admin Evergreen.V10.Pages.Admin.Model
    | Credits Evergreen.V10.Pages.Credits.Model
    | Lists Evergreen.V10.Pages.Lists.Model
    | Lists_Create Evergreen.V10.Pages.Lists.Create.Model
    | Lists_Edit_ListId_
        { listId : String
        }
        Evergreen.V10.Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem
        { id : String
        }
        Evergreen.V10.Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_
        { listId : String
        }
        Evergreen.V10.Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_
        { listId : String
        , itemId : String
        }
        Evergreen.V10.Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Evergreen.V10.Pages.Manual.Model
    | Settings Evergreen.V10.Pages.Settings.Model
    | Setup Evergreen.V10.Pages.Setup.Model
    | Setup_Connect Evergreen.V10.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V10.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V10.Pages.SetupKnown.Model
    | Share_ListId_
        { listId : String
        }
        Evergreen.V10.Pages.Share.ListId_.Model
    | NotFound_ Evergreen.V10.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
