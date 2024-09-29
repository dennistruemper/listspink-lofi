module Evergreen.V7.Main.Pages.Msg exposing (..)

import Evergreen.V7.Pages.Account
import Evergreen.V7.Pages.Admin
import Evergreen.V7.Pages.Credits
import Evergreen.V7.Pages.Home_
import Evergreen.V7.Pages.Lists
import Evergreen.V7.Pages.Lists.Create
import Evergreen.V7.Pages.Lists.Edit.ListId_
import Evergreen.V7.Pages.Lists.Id_.CreateItem
import Evergreen.V7.Pages.Lists.ListId_
import Evergreen.V7.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V7.Pages.Manual
import Evergreen.V7.Pages.NotFound_
import Evergreen.V7.Pages.Settings
import Evergreen.V7.Pages.Setup
import Evergreen.V7.Pages.Setup.Connect
import Evergreen.V7.Pages.Setup.NewAccount
import Evergreen.V7.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V7.Pages.Home_.Msg
    | Account Evergreen.V7.Pages.Account.Msg
    | Admin Evergreen.V7.Pages.Admin.Msg
    | Credits Evergreen.V7.Pages.Credits.Msg
    | Lists Evergreen.V7.Pages.Lists.Msg
    | Lists_Create Evergreen.V7.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V7.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V7.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V7.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V7.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V7.Pages.Manual.Msg
    | Settings Evergreen.V7.Pages.Settings.Msg
    | Setup Evergreen.V7.Pages.Setup.Msg
    | Setup_Connect Evergreen.V7.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V7.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V7.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V7.Pages.NotFound_.Msg
