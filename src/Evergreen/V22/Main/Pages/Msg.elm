module Evergreen.V22.Main.Pages.Msg exposing (..)

import Evergreen.V22.Pages.Account
import Evergreen.V22.Pages.Admin.Manual
import Evergreen.V22.Pages.Admin.Menu
import Evergreen.V22.Pages.Admin.Users
import Evergreen.V22.Pages.Credits
import Evergreen.V22.Pages.Home_
import Evergreen.V22.Pages.List.ImportShared
import Evergreen.V22.Pages.Lists
import Evergreen.V22.Pages.Lists.Create
import Evergreen.V22.Pages.Lists.Edit.ListId_
import Evergreen.V22.Pages.Lists.Id_.CreateItem
import Evergreen.V22.Pages.Lists.ListId_
import Evergreen.V22.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V22.Pages.NotFound_
import Evergreen.V22.Pages.Settings
import Evergreen.V22.Pages.Setup
import Evergreen.V22.Pages.Setup.Connect
import Evergreen.V22.Pages.Setup.NewAccount
import Evergreen.V22.Pages.SetupKnown
import Evergreen.V22.Pages.Share.ListId_


type Msg
    = Home_ Evergreen.V22.Pages.Home_.Msg
    | Account Evergreen.V22.Pages.Account.Msg
    | Admin_Manual Evergreen.V22.Pages.Admin.Manual.Msg
    | Admin_Menu Evergreen.V22.Pages.Admin.Menu.Msg
    | Admin_Users Evergreen.V22.Pages.Admin.Users.Msg
    | Credits Evergreen.V22.Pages.Credits.Msg
    | List_ImportShared Evergreen.V22.Pages.List.ImportShared.Msg
    | Lists Evergreen.V22.Pages.Lists.Msg
    | Lists_Create Evergreen.V22.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V22.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V22.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V22.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V22.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Settings Evergreen.V22.Pages.Settings.Msg
    | Setup Evergreen.V22.Pages.Setup.Msg
    | Setup_Connect Evergreen.V22.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V22.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V22.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V22.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V22.Pages.NotFound_.Msg
