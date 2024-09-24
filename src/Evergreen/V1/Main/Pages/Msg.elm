module Evergreen.V1.Main.Pages.Msg exposing (..)

import Evergreen.V1.Pages.Account
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Credits
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Lists
import Evergreen.V1.Pages.Lists.Create
import Evergreen.V1.Pages.Lists.Edit.ListId_
import Evergreen.V1.Pages.Lists.Id_.CreateItem
import Evergreen.V1.Pages.Lists.ListId_
import Evergreen.V1.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V1.Pages.Manual
import Evergreen.V1.Pages.NotFound_
import Evergreen.V1.Pages.Settings
import Evergreen.V1.Pages.Setup
import Evergreen.V1.Pages.Setup.Connect
import Evergreen.V1.Pages.Setup.NewAccount
import Evergreen.V1.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V1.Pages.Home_.Msg
    | Account Evergreen.V1.Pages.Account.Msg
    | Admin Evergreen.V1.Pages.Admin.Msg
    | Credits Evergreen.V1.Pages.Credits.Msg
    | Lists Evergreen.V1.Pages.Lists.Msg
    | Lists_Create Evergreen.V1.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V1.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V1.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V1.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V1.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Manual Evergreen.V1.Pages.Manual.Msg
    | Settings Evergreen.V1.Pages.Settings.Msg
    | Setup Evergreen.V1.Pages.Setup.Msg
    | Setup_Connect Evergreen.V1.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V1.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V1.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V1.Pages.NotFound_.Msg
