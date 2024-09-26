module Evergreen.V3.Main.Pages.Msg exposing (..)

import Evergreen.V3.Pages.Account
import Evergreen.V3.Pages.Admin
import Evergreen.V3.Pages.Credits
import Evergreen.V3.Pages.Home_
import Evergreen.V3.Pages.Lists
import Evergreen.V3.Pages.Lists.Create
import Evergreen.V3.Pages.Lists.Edit.ListId_
import Evergreen.V3.Pages.Lists.Id_.CreateItem
import Evergreen.V3.Pages.Lists.ListId_
import Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V3.Pages.Manual
import Evergreen.V3.Pages.NotFound_
import Evergreen.V3.Pages.Settings
import Evergreen.V3.Pages.Setup
import Evergreen.V3.Pages.Setup.Connect
import Evergreen.V3.Pages.Setup.NewAccount
import Evergreen.V3.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V3.Pages.Home_.Msg
    | Account Evergreen.V3.Pages.Account.Msg
    | Admin Evergreen.V3.Pages.Admin.Msg
    | Credits Evergreen.V3.Pages.Credits.Msg
    | Lists Evergreen.V3.Pages.Lists.Msg
    | Lists_Create Evergreen.V3.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V3.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V3.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V3.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V3.Pages.Manual.Msg
    | Settings Evergreen.V3.Pages.Settings.Msg
    | Setup Evergreen.V3.Pages.Setup.Msg
    | Setup_Connect Evergreen.V3.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V3.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V3.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V3.Pages.NotFound_.Msg
