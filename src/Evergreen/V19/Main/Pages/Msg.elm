module Evergreen.V19.Main.Pages.Msg exposing (..)

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


type Msg
    = Home_ Evergreen.V19.Pages.Home_.Msg
    | Account Evergreen.V19.Pages.Account.Msg
    | Admin Evergreen.V19.Pages.Admin.Msg
    | Credits Evergreen.V19.Pages.Credits.Msg
    | List_ImportShared Evergreen.V19.Pages.List.ImportShared.Msg
    | Lists Evergreen.V19.Pages.Lists.Msg
    | Lists_Create Evergreen.V19.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V19.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V19.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V19.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V19.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V19.Pages.Manual.Msg
    | Settings Evergreen.V19.Pages.Settings.Msg
    | Setup Evergreen.V19.Pages.Setup.Msg
    | Setup_Connect Evergreen.V19.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V19.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V19.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V19.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V19.Pages.NotFound_.Msg
