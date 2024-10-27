module Evergreen.V10.Main.Pages.Msg exposing (..)

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


type Msg
    = Home_ Evergreen.V10.Pages.Home_.Msg
    | Account Evergreen.V10.Pages.Account.Msg
    | Admin Evergreen.V10.Pages.Admin.Msg
    | Credits Evergreen.V10.Pages.Credits.Msg
    | Lists Evergreen.V10.Pages.Lists.Msg
    | Lists_Create Evergreen.V10.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V10.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V10.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V10.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V10.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V10.Pages.Manual.Msg
    | Settings Evergreen.V10.Pages.Settings.Msg
    | Setup Evergreen.V10.Pages.Setup.Msg
    | Setup_Connect Evergreen.V10.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V10.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V10.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V10.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V10.Pages.NotFound_.Msg
