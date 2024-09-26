module Evergreen.V4.Main.Pages.Msg exposing (..)

import Evergreen.V4.Pages.Account
import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.Credits
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Lists
import Evergreen.V4.Pages.Lists.Create
import Evergreen.V4.Pages.Lists.Edit.ListId_
import Evergreen.V4.Pages.Lists.Id_.CreateItem
import Evergreen.V4.Pages.Lists.ListId_
import Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V4.Pages.Manual
import Evergreen.V4.Pages.NotFound_
import Evergreen.V4.Pages.Settings
import Evergreen.V4.Pages.Setup
import Evergreen.V4.Pages.Setup.Connect
import Evergreen.V4.Pages.Setup.NewAccount
import Evergreen.V4.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V4.Pages.Home_.Msg
    | Account Evergreen.V4.Pages.Account.Msg
    | Admin Evergreen.V4.Pages.Admin.Msg
    | Credits Evergreen.V4.Pages.Credits.Msg
    | Lists Evergreen.V4.Pages.Lists.Msg
    | Lists_Create Evergreen.V4.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V4.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V4.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V4.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V4.Pages.Manual.Msg
    | Settings Evergreen.V4.Pages.Settings.Msg
    | Setup Evergreen.V4.Pages.Setup.Msg
    | Setup_Connect Evergreen.V4.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V4.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V4.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V4.Pages.NotFound_.Msg
