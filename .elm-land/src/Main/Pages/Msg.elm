module Main.Pages.Msg exposing (Msg(..))

import Pages.Home_
import Pages.Account
import Pages.Admin
import Pages.Lists
import Pages.Lists.Create
import Pages.Lists.Id_.CreateItem
import Pages.Lists.ListId_
import Pages.Manual
import Pages.Settings
import Pages.Setup
import Pages.Setup.Connect
import Pages.Setup.NewAccount
import Pages.SetupKnown
import Pages.NotFound_


type Msg
    = Home_ Pages.Home_.Msg
    | Account Pages.Account.Msg
    | Admin Pages.Admin.Msg
    | Lists Pages.Lists.Msg
    | Lists_Create Pages.Lists.Create.Msg
    | Lists_Id__CreateItem Pages.Lists.Id_.CreateItem.Msg
    | Lists_ListId_ Pages.Lists.ListId_.Msg
    | Manual Pages.Manual.Msg
    | Settings Pages.Settings.Msg
    | Setup Pages.Setup.Msg
    | Setup_Connect Pages.Setup.Connect.Msg
    | Setup_NewAccount Pages.Setup.NewAccount.Msg
    | SetupKnown Pages.SetupKnown.Msg
    | NotFound_ Pages.NotFound_.Msg
