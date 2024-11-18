module Evergreen.V12.Main.Pages.Msg exposing (..)

import Evergreen.V12.Pages.Account
import Evergreen.V12.Pages.Admin
import Evergreen.V12.Pages.Credits
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.List.ImportShared
import Evergreen.V12.Pages.Lists
import Evergreen.V12.Pages.Lists.Create
import Evergreen.V12.Pages.Lists.Edit.ListId_
import Evergreen.V12.Pages.Lists.Id_.CreateItem
import Evergreen.V12.Pages.Lists.ListId_
import Evergreen.V12.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V12.Pages.Manual
import Evergreen.V12.Pages.NotFound_
import Evergreen.V12.Pages.Settings
import Evergreen.V12.Pages.Setup
import Evergreen.V12.Pages.Setup.Connect
import Evergreen.V12.Pages.Setup.NewAccount
import Evergreen.V12.Pages.SetupKnown
import Evergreen.V12.Pages.Share.ListId_


type Msg
    = Home_ Evergreen.V12.Pages.Home_.Msg
    | Account Evergreen.V12.Pages.Account.Msg
    | Admin Evergreen.V12.Pages.Admin.Msg
    | Credits Evergreen.V12.Pages.Credits.Msg
    | List_ImportShared Evergreen.V12.Pages.List.ImportShared.Msg
    | Lists Evergreen.V12.Pages.Lists.Msg
    | Lists_Create Evergreen.V12.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V12.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V12.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V12.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V12.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V12.Pages.Manual.Msg
    | Settings Evergreen.V12.Pages.Settings.Msg
    | Setup Evergreen.V12.Pages.Setup.Msg
    | Setup_Connect Evergreen.V12.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V12.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V12.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V12.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V12.Pages.NotFound_.Msg
