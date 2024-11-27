module Evergreen.V20.Main.Pages.Msg exposing (..)

import Evergreen.V20.Pages.Account
import Evergreen.V20.Pages.Admin.Manual
import Evergreen.V20.Pages.Admin.Menu
import Evergreen.V20.Pages.Admin.Users
import Evergreen.V20.Pages.Credits
import Evergreen.V20.Pages.Home_
import Evergreen.V20.Pages.List.ImportShared
import Evergreen.V20.Pages.Lists
import Evergreen.V20.Pages.Lists.Create
import Evergreen.V20.Pages.Lists.Edit.ListId_
import Evergreen.V20.Pages.Lists.Id_.CreateItem
import Evergreen.V20.Pages.Lists.ListId_
import Evergreen.V20.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V20.Pages.NotFound_
import Evergreen.V20.Pages.Settings
import Evergreen.V20.Pages.Setup
import Evergreen.V20.Pages.Setup.Connect
import Evergreen.V20.Pages.Setup.NewAccount
import Evergreen.V20.Pages.SetupKnown
import Evergreen.V20.Pages.Share.ListId_


type Msg
    = Home_ Evergreen.V20.Pages.Home_.Msg
    | Account Evergreen.V20.Pages.Account.Msg
    | Admin_Manual Evergreen.V20.Pages.Admin.Manual.Msg
    | Admin_Menu Evergreen.V20.Pages.Admin.Menu.Msg
    | Admin_Users Evergreen.V20.Pages.Admin.Users.Msg
    | Credits Evergreen.V20.Pages.Credits.Msg
    | List_ImportShared Evergreen.V20.Pages.List.ImportShared.Msg
    | Lists Evergreen.V20.Pages.Lists.Msg
    | Lists_Create Evergreen.V20.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V20.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V20.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V20.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V20.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Settings Evergreen.V20.Pages.Settings.Msg
    | Setup Evergreen.V20.Pages.Setup.Msg
    | Setup_Connect Evergreen.V20.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V20.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V20.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V20.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V20.Pages.NotFound_.Msg
