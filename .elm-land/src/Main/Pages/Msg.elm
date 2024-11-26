module Main.Pages.Msg exposing (Msg(..))

import Pages.Home_
import Pages.Account
import Pages.Admin.Manual
import Pages.Admin.Menu
import Pages.Credits
import Pages.List.ImportShared
import Pages.Lists
import Pages.Lists.Create
import Pages.Lists.Edit.ListId_
import Pages.Lists.Id_.CreateItem
import Pages.Lists.ListId_
import Pages.Lists.ListId_.Edit.ItemId_
import Pages.Settings
import Pages.Setup
import Pages.Setup.Connect
import Pages.Setup.NewAccount
import Pages.SetupKnown
import Pages.Share.ListId_
import Pages.NotFound_


type Msg
    = Home_ Pages.Home_.Msg
    | Account Pages.Account.Msg
    | Admin_Manual Pages.Admin.Manual.Msg
    | Admin_Menu Pages.Admin.Menu.Msg
    | Credits Pages.Credits.Msg
    | List_ImportShared Pages.List.ImportShared.Msg
    | Lists Pages.Lists.Msg
    | Lists_Create Pages.Lists.Create.Msg
    | Lists_Edit_ListId_ Pages.Lists.Edit.ListId_.Msg
    | Lists_Id__CreateItem Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Pages.Lists.ListId_.Msg
    | Lists_ListId__Edit_ItemId_ Pages.Lists.ListId_.Edit.ItemId_.Msg
    | Settings Pages.Settings.Msg
    | Setup Pages.Setup.Msg
    | Setup_Connect Pages.Setup.Connect.Msg
    | Setup_NewAccount Pages.Setup.NewAccount.Msg
    | SetupKnown Pages.SetupKnown.Msg
    | Share_ListId_ Pages.Share.ListId_.Msg
    | NotFound_ Pages.NotFound_.Msg
