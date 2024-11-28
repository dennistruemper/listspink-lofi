module Evergreen.V21.Main.Pages.Msg exposing (..)

import Evergreen.V21.Pages.Account
import Evergreen.V21.Pages.Admin.Manual
import Evergreen.V21.Pages.Admin.Menu
import Evergreen.V21.Pages.Admin.Users
import Evergreen.V21.Pages.Credits
import Evergreen.V21.Pages.Home_
import Evergreen.V21.Pages.List.ImportShared
import Evergreen.V21.Pages.Lists
import Evergreen.V21.Pages.Lists.Create
import Evergreen.V21.Pages.Lists.Edit.ListId_
import Evergreen.V21.Pages.Lists.Id_.CreateItem
import Evergreen.V21.Pages.Lists.ListId_
import Evergreen.V21.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V21.Pages.NotFound_
import Evergreen.V21.Pages.Settings
import Evergreen.V21.Pages.Setup
import Evergreen.V21.Pages.Setup.Connect
import Evergreen.V21.Pages.Setup.NewAccount
import Evergreen.V21.Pages.SetupKnown
import Evergreen.V21.Pages.Share.ListId_


type Msg
    = Home_ Evergreen.V21.Pages.Home_.Msg
    | Account Evergreen.V21.Pages.Account.Msg
    | Admin_Manual Evergreen.V21.Pages.Admin.Manual.Msg
    | Admin_Menu Evergreen.V21.Pages.Admin.Menu.Msg
    | Admin_Users Evergreen.V21.Pages.Admin.Users.Msg
    | Credits Evergreen.V21.Pages.Credits.Msg
    | List_ImportShared Evergreen.V21.Pages.List.ImportShared.Msg
    | Lists Evergreen.V21.Pages.Lists.Msg
    | Lists_Create Evergreen.V21.Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Evergreen.V21.Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Evergreen.V21.Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Evergreen.V21.Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Evergreen.V21.Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Settings Evergreen.V21.Pages.Settings.Msg
    | Setup Evergreen.V21.Pages.Setup.Msg
    | Setup_Connect Evergreen.V21.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V21.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V21.Pages.SetupKnown.Msg
    | Share_ListId_ Evergreen.V21.Pages.Share.ListId_.Msg
    | NotFound_ Evergreen.V21.Pages.NotFound_.Msg
