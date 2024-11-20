module Evergreen.V13.Main.Pages.Msg exposing (..)

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


type Msg
    = Home_ Evergreen.V13.Pages.Home_.Msg
    | Account Evergreen.V13.Pages.Account.Msg
    | Admin Evergreen.V13.Pages.Admin.Msg
    | Credits Evergreen.V13.Pages.Credits.Msg
    | List_ImportShared Evergreen.V13.Pages.List.ImportShared.Msg
    | Lists Evergreen.V13.Pages.Lists.Msg
    | Lists_Create Evergreen.V13.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V13.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V13.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V13.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V13.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V13.Pages.Manual.Msg
    | Settings Evergreen.V13.Pages.Settings.Msg
    | Setup Evergreen.V13.Pages.Setup.Msg
    | Setup_Connect Evergreen.V13.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V13.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V13.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V13.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V13.Pages.NotFound_.Msg
