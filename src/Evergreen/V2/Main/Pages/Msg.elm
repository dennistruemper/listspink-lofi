module Evergreen.V2.Main.Pages.Msg exposing (..)

import Evergreen.V2.Pages.Account
import Evergreen.V2.Pages.Admin
import Evergreen.V2.Pages.Credits
import Evergreen.V2.Pages.Home_
import Evergreen.V2.Pages.Lists
import Evergreen.V2.Pages.Lists.Create
import Evergreen.V2.Pages.Lists.Edit.ListId_
import Evergreen.V2.Pages.Lists.Id_.CreateItem
import Evergreen.V2.Pages.Lists.ListId_
import Evergreen.V2.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V2.Pages.Manual
import Evergreen.V2.Pages.NotFound_
import Evergreen.V2.Pages.Settings
import Evergreen.V2.Pages.Setup
import Evergreen.V2.Pages.Setup.Connect
import Evergreen.V2.Pages.Setup.NewAccount
import Evergreen.V2.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V2.Pages.Home_.Msg
    | Account Evergreen.V2.Pages.Account.Msg
    | Admin Evergreen.V2.Pages.Admin.Msg
    | Credits Evergreen.V2.Pages.Credits.Msg
    | Lists Evergreen.V2.Pages.Lists.Msg
    | Lists_Create Evergreen.V2.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V2.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V2.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V2.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V2.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V2.Pages.Manual.Msg
    | Settings Evergreen.V2.Pages.Settings.Msg
    | Setup Evergreen.V2.Pages.Setup.Msg
    | Setup_Connect Evergreen.V2.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V2.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V2.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V2.Pages.NotFound_.Msg
