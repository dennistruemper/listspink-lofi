module Evergreen.V15.Main.Pages.Msg exposing (..)

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


type Msg
    = Home_ Evergreen.V15.Pages.Home_.Msg
    | Account Evergreen.V15.Pages.Account.Msg
    | Admin Evergreen.V15.Pages.Admin.Msg
    | Credits Evergreen.V15.Pages.Credits.Msg
    | List_ImportShared Evergreen.V15.Pages.List.ImportShared.Msg
    | Lists Evergreen.V15.Pages.Lists.Msg
    | Lists_Create Evergreen.V15.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V15.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V15.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V15.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V15.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V15.Pages.Manual.Msg
    | Settings Evergreen.V15.Pages.Settings.Msg
    | Setup Evergreen.V15.Pages.Setup.Msg
    | Setup_Connect Evergreen.V15.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V15.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V15.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V15.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V15.Pages.NotFound_.Msg
