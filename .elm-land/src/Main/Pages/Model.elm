module Main.Pages.Model exposing (Model(..))

import Pages.Home_
import Pages.Account
import Pages.Admin
import Pages.Credits
import Pages.Lists
import Pages.Lists.Create
import Pages.Lists.Edit.ListId_
import Pages.Lists.Id_.CreateItem
import Pages.Lists.ListId_
import Pages.Lists.ListId_.Edit.ItemId_
import Pages.Manual
import Pages.Settings
import Pages.Setup
import Pages.Setup.Connect
import Pages.Setup.NewAccount
import Pages.SetupKnown
import Pages.Share.ListId_
import Pages.NotFound_
import View exposing (View)


type Model
    = Home_ Pages.Home_.Model
    | Account Pages.Account.Model
    | Admin Pages.Admin.Model
    | Credits Pages.Credits.Model
    | Lists Pages.Lists.Model
    | Lists_Create Pages.Lists.Create.Model
    | Lists_Edit_ListId_ { listId : String } Pages.Lists.Edit.ListId_.Model
    | Lists_Id__CreateItem { id : String } Pages.Lists.Id_.CreateItem.Model
    | Lists_ListId_ { listId : String } Pages.Lists.ListId_.Model
    | Lists_ListId__Edit_ItemId_ { listId : String, itemId : String } Pages.Lists.ListId_.Edit.ItemId_.Model
    | Manual Pages.Manual.Model
    | Settings Pages.Settings.Model
    | Setup Pages.Setup.Model
    | Setup_Connect Pages.Setup.Connect.Model
    | Setup_NewAccount Pages.Setup.NewAccount.Model
    | SetupKnown Pages.SetupKnown.Model
    | Share_ListId_ { listId : String } Pages.Share.ListId_.Model
    | NotFound_ Pages.NotFound_.Model
    | Redirecting_
    | Loading_
