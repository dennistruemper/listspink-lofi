module Evergreen.Migrate.V4 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.app/docs/evergreen> for more info.

-}

import Array
import Dict
import Evergreen.V3.Auth
import Evergreen.V3.Bridge
import Evergreen.V3.Event
import Evergreen.V3.ItemPriority
import Evergreen.V3.Layouts.Scaffold
import Evergreen.V3.Main
import Evergreen.V3.Main.Layouts.Model
import Evergreen.V3.Main.Layouts.Msg
import Evergreen.V3.Main.Pages.Model
import Evergreen.V3.Main.Pages.Msg
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
import Evergreen.V3.Route.Path
import Evergreen.V3.Shared
import Evergreen.V3.Shared.Model
import Evergreen.V3.Shared.Msg
import Evergreen.V3.SortedEventList
import Evergreen.V3.Subscriptions
import Evergreen.V3.Sync
import Evergreen.V3.Types
import Evergreen.V3.UserManagement
import Evergreen.V4.Auth
import Evergreen.V4.Bridge
import Evergreen.V4.Event
import Evergreen.V4.ItemPriority
import Evergreen.V4.Layouts.Scaffold
import Evergreen.V4.Main
import Evergreen.V4.Main.Layouts.Model
import Evergreen.V4.Main.Layouts.Msg
import Evergreen.V4.Main.Pages.Model
import Evergreen.V4.Main.Pages.Msg
import Evergreen.V4.Pages.Account
import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.Credits
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Lists
import Evergreen.V4.Pages.Lists.Create
import Evergreen.V4.Pages.Lists.Edit.ListId_
import Evergreen.V4.Pages.Lists.Id_.CreateItem
import Evergreen.V4.Pages.Lists.ListId_
import Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_
import Evergreen.V4.Pages.Manual
import Evergreen.V4.Pages.NotFound_
import Evergreen.V4.Pages.Settings
import Evergreen.V4.Pages.Setup
import Evergreen.V4.Pages.Setup.Connect
import Evergreen.V4.Pages.Setup.NewAccount
import Evergreen.V4.Pages.SetupKnown
import Evergreen.V4.Route.Path
import Evergreen.V4.Shared
import Evergreen.V4.Shared.Model
import Evergreen.V4.Shared.Msg
import Evergreen.V4.SortedEventList
import Evergreen.V4.Subscriptions
import Evergreen.V4.Sync
import Evergreen.V4.Types
import Evergreen.V4.UserManagement
import Lamdera.Migrations exposing (..)
import Maybe
import Time


frontendModel : Evergreen.V3.Types.FrontendModel -> ModelMigration Evergreen.V4.Types.FrontendModel Evergreen.V4.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V3.Types.BackendModel -> ModelMigration Evergreen.V4.Types.BackendModel Evergreen.V4.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V3.Types.FrontendMsg -> MsgMigration Evergreen.V4.Types.FrontendMsg Evergreen.V4.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V3.Types.ToBackend -> MsgMigration Evergreen.V4.Types.ToBackend Evergreen.V4.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V3.Types.BackendMsg -> MsgMigration Evergreen.V4.Types.BackendMsg Evergreen.V4.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V3.Types.ToFrontend -> MsgMigration Evergreen.V4.Types.ToFrontend Evergreen.V4.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_FrontendModel : Evergreen.V3.Types.FrontendModel -> Evergreen.V4.Types.FrontendModel
migrate_Types_FrontendModel old =
    old |> migrate_Main_Model


migrate_Types_FrontendMsg : Evergreen.V3.Types.FrontendMsg -> Evergreen.V4.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    old |> migrate_Main_Msg


migrate_Auth_User : Evergreen.V3.Auth.User -> Evergreen.V4.Auth.User
migrate_Auth_User old =
    old |> migrate_Bridge_User


migrate_Bridge_User : Evergreen.V3.Bridge.User -> Evergreen.V4.Bridge.User
migrate_Bridge_User old =
    case old of
        Evergreen.V3.Bridge.Unknown ->
            Evergreen.V4.Bridge.Unknown

        Evergreen.V3.Bridge.UserOnDevice p0 ->
            Evergreen.V4.Bridge.UserOnDevice (p0 |> migrate_Bridge_UserOnDeviceData)


migrate_Bridge_UserOnDeviceData : Evergreen.V3.Bridge.UserOnDeviceData -> Evergreen.V4.Bridge.UserOnDeviceData
migrate_Bridge_UserOnDeviceData old =
    old |> migrate_UserManagement_UserOnDeviceData


migrate_Event_EventData : Evergreen.V3.Event.EventData -> Evergreen.V4.Event.EventData
migrate_Event_EventData old =
    case old of
        Evergreen.V3.Event.ListCreated p0 ->
            Evergreen.V4.Event.ListCreated (p0 |> migrate_Event_ListCreatedData)

        Evergreen.V3.Event.ListUpdated p0 ->
            Evergreen.V4.Event.ListUpdated (p0 |> migrate_Event_ListUpdatedData)

        Evergreen.V3.Event.ItemCreated p0 ->
            Evergreen.V4.Event.ItemCreated (p0 |> migrate_Event_ItemCreatedData)

        Evergreen.V3.Event.ItemStateChanged p0 ->
            Evergreen.V4.Event.ItemStateChanged (p0 |> migrate_Event_ItemStateChangedData)

        Evergreen.V3.Event.ItemUpdated p0 ->
            Evergreen.V4.Event.ItemUpdated (p0 |> migrate_Event_ItemUpdatedData)


migrate_Event_EventDefinition : Evergreen.V3.Event.EventDefinition -> Evergreen.V4.Event.EventDefinition
migrate_Event_EventDefinition old =
    case old of
        Evergreen.V3.Event.Event p0 p1 ->
            Evergreen.V4.Event.Event (p0 |> migrate_Event_EventMetadata)
                (p1 |> migrate_Event_EventData)


migrate_Event_EventMetadata : Evergreen.V3.Event.EventMetadata -> Evergreen.V4.Event.EventMetadata
migrate_Event_EventMetadata old =
    old


migrate_Event_ItemCreatedData : Evergreen.V3.Event.ItemCreatedData -> Evergreen.V4.Event.ItemCreatedData
migrate_Event_ItemCreatedData old =
    { itemId = old.itemId
    , itemName = old.itemName
    , itemDescription = old.itemDescription
    , itemPriority = old.itemPriority |> Maybe.map migrate_ItemPriority_ItemPriority
    }


migrate_Event_ItemStateChangedData : Evergreen.V3.Event.ItemStateChangedData -> Evergreen.V4.Event.ItemStateChangedData
migrate_Event_ItemStateChangedData old =
    old


migrate_Event_ItemUpdatedData : Evergreen.V3.Event.ItemUpdatedData -> Evergreen.V4.Event.ItemUpdatedData
migrate_Event_ItemUpdatedData old =
    { itemId = old.itemId
    , listId = old.listId
    , name = old.name
    , completed = old.completed
    , itemPriority = old.itemPriority |> Maybe.map migrate_ItemPriority_ItemPriority
    , description = old.description
    }


migrate_Event_ListCreatedData : Evergreen.V3.Event.ListCreatedData -> Evergreen.V4.Event.ListCreatedData
migrate_Event_ListCreatedData old =
    old


migrate_Event_ListUpdatedData : Evergreen.V3.Event.ListUpdatedData -> Evergreen.V4.Event.ListUpdatedData
migrate_Event_ListUpdatedData old =
    old


migrate_Event_PinkItem : Evergreen.V3.Event.PinkItem -> Evergreen.V4.Event.PinkItem
migrate_Event_PinkItem old =
    { name = old.name
    , itemId = old.itemId
    , description = old.description
    , createdAt = old.createdAt
    , completedAt = old.completedAt
    , lastUpdatedAt = old.lastUpdatedAt
    , numberOfUpdates = old.numberOfUpdates
    , priority = old.priority |> migrate_ItemPriority_ItemPriority
    }


migrate_Event_PinkList : Evergreen.V3.Event.PinkList -> Evergreen.V4.Event.PinkList
migrate_Event_PinkList old =
    { name = old.name
    , listId = old.listId
    , items = old.items |> Dict.map (\k -> migrate_Event_PinkItem)
    , createdAt = old.createdAt
    , lastUpdatedAt = old.lastUpdatedAt
    , numberOfUpdates = old.numberOfUpdates
    }


migrate_Event_State : Evergreen.V3.Event.State -> Evergreen.V4.Event.State
migrate_Event_State old =
    { lists = old.lists |> Dict.map (\k -> migrate_Event_PinkList)
    }


migrate_ItemPriority_ItemPriority : Evergreen.V3.ItemPriority.ItemPriority -> Evergreen.V4.ItemPriority.ItemPriority
migrate_ItemPriority_ItemPriority old =
    case old of
        Evergreen.V3.ItemPriority.LowItemPriority ->
            Evergreen.V4.ItemPriority.LowItemPriority

        Evergreen.V3.ItemPriority.MediumItemPriority ->
            Evergreen.V4.ItemPriority.MediumItemPriority

        Evergreen.V3.ItemPriority.HighItemPriority ->
            Evergreen.V4.ItemPriority.HighItemPriority

        Evergreen.V3.ItemPriority.HighestItemPriority ->
            Evergreen.V4.ItemPriority.HighestItemPriority


migrate_Layouts_Scaffold_Model : Evergreen.V3.Layouts.Scaffold.Model -> Evergreen.V4.Layouts.Scaffold.Model
migrate_Layouts_Scaffold_Model old =
    { user = old.user |> migrate_Auth_User
    }


migrate_Layouts_Scaffold_Msg : Evergreen.V3.Layouts.Scaffold.Msg -> Evergreen.V4.Layouts.Scaffold.Msg
migrate_Layouts_Scaffold_Msg old =
    case old of
        Evergreen.V3.Layouts.Scaffold.CloseSidebarClicked ->
            Evergreen.V4.Layouts.Scaffold.CloseSidebarClicked

        Evergreen.V3.Layouts.Scaffold.OpenSidebarClicked ->
            Evergreen.V4.Layouts.Scaffold.OpenSidebarClicked

        Evergreen.V3.Layouts.Scaffold.NavigationClicked p0 ->
            Evergreen.V4.Layouts.Scaffold.NavigationClicked (p0 |> migrate_Route_Path_Path)


migrate_Main_Layouts_Model_Model : Evergreen.V3.Main.Layouts.Model.Model -> Evergreen.V4.Main.Layouts.Model.Model
migrate_Main_Layouts_Model_Model old =
    case old of
        Evergreen.V3.Main.Layouts.Model.Scaffold p0 ->
            Evergreen.V4.Main.Layouts.Model.Scaffold
                { scaffold = p0.scaffold |> migrate_Layouts_Scaffold_Model
                }


migrate_Main_Layouts_Msg_Msg : Evergreen.V3.Main.Layouts.Msg.Msg -> Evergreen.V4.Main.Layouts.Msg.Msg
migrate_Main_Layouts_Msg_Msg old =
    case old of
        Evergreen.V3.Main.Layouts.Msg.Scaffold p0 ->
            Evergreen.V4.Main.Layouts.Msg.Scaffold (p0 |> migrate_Layouts_Scaffold_Msg)


migrate_Main_Model : Evergreen.V3.Main.Model -> Evergreen.V4.Main.Model
migrate_Main_Model old =
    { key = old.key
    , url = old.url
    , page = old.page |> migrate_Main_Pages_Model_Model
    , layout = old.layout |> Maybe.map migrate_Main_Layouts_Model_Model
    , shared = old.shared |> migrate_Shared_Model
    }


migrate_Main_Msg : Evergreen.V3.Main.Msg -> Evergreen.V4.Main.Msg
migrate_Main_Msg old =
    case old of
        Evergreen.V3.Main.UrlRequested p0 ->
            Evergreen.V4.Main.UrlRequested p0

        Evergreen.V3.Main.UrlChanged p0 ->
            Evergreen.V4.Main.UrlChanged p0

        Evergreen.V3.Main.Page p0 ->
            Evergreen.V4.Main.Page (p0 |> migrate_Main_Pages_Msg_Msg)

        Evergreen.V3.Main.Layout p0 ->
            Evergreen.V4.Main.Layout (p0 |> migrate_Main_Layouts_Msg_Msg)

        Evergreen.V3.Main.Shared p0 ->
            Evergreen.V4.Main.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V3.Main.Batch p0 ->
            Evergreen.V4.Main.Batch (p0 |> List.map migrate_Main_Msg)


migrate_Main_Pages_Model_Model : Evergreen.V3.Main.Pages.Model.Model -> Evergreen.V4.Main.Pages.Model.Model
migrate_Main_Pages_Model_Model old =
    case old of
        Evergreen.V3.Main.Pages.Model.Home_ p0 ->
            Evergreen.V4.Main.Pages.Model.Home_ (p0 |> migrate_Pages_Home__Model)

        Evergreen.V3.Main.Pages.Model.Account p0 ->
            Evergreen.V4.Main.Pages.Model.Account (p0 |> migrate_Pages_Account_Model)

        Evergreen.V3.Main.Pages.Model.Admin p0 ->
            Evergreen.V4.Main.Pages.Model.Admin (p0 |> migrate_Pages_Admin_Model)

        Evergreen.V3.Main.Pages.Model.Credits p0 ->
            Evergreen.V4.Main.Pages.Model.Credits (p0 |> migrate_Pages_Credits_Model)

        Evergreen.V3.Main.Pages.Model.Lists p0 ->
            Evergreen.V4.Main.Pages.Model.Lists (p0 |> migrate_Pages_Lists_Model)

        Evergreen.V3.Main.Pages.Model.Lists_Create p0 ->
            Evergreen.V4.Main.Pages.Model.Lists_Create (p0 |> migrate_Pages_Lists_Create_Model)

        Evergreen.V3.Main.Pages.Model.Lists_Edit_ListId_ p0 p1 ->
            Evergreen.V4.Main.Pages.Model.Lists_Edit_ListId_ p0 (p1 |> migrate_Pages_Lists_Edit_ListId__Model)

        Evergreen.V3.Main.Pages.Model.Lists_Id__CreateItem p0 p1 ->
            Evergreen.V4.Main.Pages.Model.Lists_Id__CreateItem p0
                (p1 |> migrate_Pages_Lists_Id__CreateItem_Model)

        Evergreen.V3.Main.Pages.Model.Lists_ListId_ p0 p1 ->
            Evergreen.V4.Main.Pages.Model.Lists_ListId_ p0 (p1 |> migrate_Pages_Lists_ListId__Model)

        Evergreen.V3.Main.Pages.Model.Lists_ListId__Edit_ItemId_ p0 p1 ->
            Evergreen.V4.Main.Pages.Model.Lists_ListId__Edit_ItemId_ p0
                (p1 |> migrate_Pages_Lists_ListId__Edit_ItemId__Model)

        Evergreen.V3.Main.Pages.Model.Manual p0 ->
            Evergreen.V4.Main.Pages.Model.Manual (p0 |> migrate_Pages_Manual_Model)

        Evergreen.V3.Main.Pages.Model.Settings p0 ->
            Evergreen.V4.Main.Pages.Model.Settings (p0 |> migrate_Pages_Settings_Model)

        Evergreen.V3.Main.Pages.Model.Setup p0 ->
            Evergreen.V4.Main.Pages.Model.Setup (p0 |> migrate_Pages_Setup_Model)

        Evergreen.V3.Main.Pages.Model.Setup_Connect p0 ->
            Evergreen.V4.Main.Pages.Model.Setup_Connect (p0 |> migrate_Pages_Setup_Connect_Model)

        Evergreen.V3.Main.Pages.Model.Setup_NewAccount p0 ->
            Evergreen.V4.Main.Pages.Model.Setup_NewAccount (p0 |> migrate_Pages_Setup_NewAccount_Model)

        Evergreen.V3.Main.Pages.Model.SetupKnown p0 ->
            Evergreen.V4.Main.Pages.Model.SetupKnown (p0 |> migrate_Pages_SetupKnown_Model)

        Evergreen.V3.Main.Pages.Model.NotFound_ p0 ->
            Evergreen.V4.Main.Pages.Model.NotFound_ (p0 |> migrate_Pages_NotFound__Model)

        Evergreen.V3.Main.Pages.Model.Redirecting_ ->
            Evergreen.V4.Main.Pages.Model.Redirecting_

        Evergreen.V3.Main.Pages.Model.Loading_ ->
            Evergreen.V4.Main.Pages.Model.Loading_


migrate_Main_Pages_Msg_Msg : Evergreen.V3.Main.Pages.Msg.Msg -> Evergreen.V4.Main.Pages.Msg.Msg
migrate_Main_Pages_Msg_Msg old =
    case old of
        Evergreen.V3.Main.Pages.Msg.Home_ p0 ->
            Evergreen.V4.Main.Pages.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V3.Main.Pages.Msg.Account p0 ->
            Evergreen.V4.Main.Pages.Msg.Account (p0 |> migrate_Pages_Account_Msg)

        Evergreen.V3.Main.Pages.Msg.Admin p0 ->
            Evergreen.V4.Main.Pages.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V3.Main.Pages.Msg.Credits p0 ->
            Evergreen.V4.Main.Pages.Msg.Credits (p0 |> migrate_Pages_Credits_Msg)

        Evergreen.V3.Main.Pages.Msg.Lists p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists (p0 |> migrate_Pages_Lists_Msg)

        Evergreen.V3.Main.Pages.Msg.Lists_Create p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists_Create (p0 |> migrate_Pages_Lists_Create_Msg)

        Evergreen.V3.Main.Pages.Msg.Lists_Edit_ListId_ p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists_Edit_ListId_ (p0 |> migrate_Pages_Lists_Edit_ListId__Msg)

        Evergreen.V3.Main.Pages.Msg.Lists_Id__CreateItem p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists_Id__CreateItem (p0 |> migrate_Pages_Lists_Id__CreateItem_Msg)

        Evergreen.V3.Main.Pages.Msg.Lists_ListId_ p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists_ListId_ (p0 |> migrate_Pages_Lists_ListId__Msg)

        Evergreen.V3.Main.Pages.Msg.Lists_ListId__Edit_ItemId_ p0 ->
            Evergreen.V4.Main.Pages.Msg.Lists_ListId__Edit_ItemId_ (p0 |> migrate_Pages_Lists_ListId__Edit_ItemId__Msg)

        Evergreen.V3.Main.Pages.Msg.Manual p0 ->
            Evergreen.V4.Main.Pages.Msg.Manual (p0 |> migrate_Pages_Manual_Msg)

        Evergreen.V3.Main.Pages.Msg.Settings p0 ->
            Evergreen.V4.Main.Pages.Msg.Settings (p0 |> migrate_Pages_Settings_Msg)

        Evergreen.V3.Main.Pages.Msg.Setup p0 ->
            Evergreen.V4.Main.Pages.Msg.Setup (p0 |> migrate_Pages_Setup_Msg)

        Evergreen.V3.Main.Pages.Msg.Setup_Connect p0 ->
            Evergreen.V4.Main.Pages.Msg.Setup_Connect (p0 |> migrate_Pages_Setup_Connect_Msg)

        Evergreen.V3.Main.Pages.Msg.Setup_NewAccount p0 ->
            Evergreen.V4.Main.Pages.Msg.Setup_NewAccount (p0 |> migrate_Pages_Setup_NewAccount_Msg)

        Evergreen.V3.Main.Pages.Msg.SetupKnown p0 ->
            Evergreen.V4.Main.Pages.Msg.SetupKnown (p0 |> migrate_Pages_SetupKnown_Msg)

        Evergreen.V3.Main.Pages.Msg.NotFound_ p0 ->
            Evergreen.V4.Main.Pages.Msg.NotFound_ (p0 |> migrate_Pages_NotFound__Msg)


migrate_Pages_Account_Model : Evergreen.V3.Pages.Account.Model -> Evergreen.V4.Pages.Account.Model
migrate_Pages_Account_Model old =
    old


migrate_Pages_Account_Msg : Evergreen.V3.Pages.Account.Msg -> Evergreen.V4.Pages.Account.Msg
migrate_Pages_Account_Msg old =
    case old of
        Evergreen.V3.Pages.Account.NoOp ->
            Evergreen.V4.Pages.Account.NoOp

        Evergreen.V3.Pages.Account.LogoutClicked ->
            Evergreen.V4.Pages.Account.LogoutClicked

        Evergreen.V3.Pages.Account.ConnectDeviceClicked ->
            Evergreen.V4.Pages.Account.ConnectDeviceClicked


migrate_Pages_Admin_Model : Evergreen.V3.Pages.Admin.Model -> Evergreen.V4.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V3.Pages.Admin.Msg -> Evergreen.V4.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V3.Pages.Admin.NoOp ->
            Evergreen.V4.Pages.Admin.NoOp


migrate_Pages_Credits_Model : Evergreen.V3.Pages.Credits.Model -> Evergreen.V4.Pages.Credits.Model
migrate_Pages_Credits_Model old =
    old


migrate_Pages_Credits_Msg : Evergreen.V3.Pages.Credits.Msg -> Evergreen.V4.Pages.Credits.Msg
migrate_Pages_Credits_Msg old =
    case old of
        Evergreen.V3.Pages.Credits.NoOp ->
            Evergreen.V4.Pages.Credits.NoOp


migrate_Pages_Home__Model : Evergreen.V3.Pages.Home_.Model -> Evergreen.V4.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V3.Pages.Home_.Msg -> Evergreen.V4.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V3.Pages.Home_.LogoutClicked ->
            Evergreen.V4.Pages.Home_.LogoutClicked


migrate_Pages_Lists_Create_Model : Evergreen.V3.Pages.Lists.Create.Model -> Evergreen.V4.Pages.Lists.Create.Model
migrate_Pages_Lists_Create_Model old =
    old


migrate_Pages_Lists_Create_Msg : Evergreen.V3.Pages.Lists.Create.Msg -> Evergreen.V4.Pages.Lists.Create.Msg
migrate_Pages_Lists_Create_Msg old =
    case old of
        Evergreen.V3.Pages.Lists.Create.ListNameChanged p0 ->
            Evergreen.V4.Pages.Lists.Create.ListNameChanged p0

        Evergreen.V3.Pages.Lists.Create.CreateListButtonClicked ->
            Evergreen.V4.Pages.Lists.Create.CreateListButtonClicked

        Evergreen.V3.Pages.Lists.Create.GotTimeForCreateList p0 ->
            Evergreen.V4.Pages.Lists.Create.GotTimeForCreateList p0


migrate_Pages_Lists_Edit_ListId__Model : Evergreen.V3.Pages.Lists.Edit.ListId_.Model -> Evergreen.V4.Pages.Lists.Edit.ListId_.Model
migrate_Pages_Lists_Edit_ListId__Model old =
    old


migrate_Pages_Lists_Edit_ListId__Msg : Evergreen.V3.Pages.Lists.Edit.ListId_.Msg -> Evergreen.V4.Pages.Lists.Edit.ListId_.Msg
migrate_Pages_Lists_Edit_ListId__Msg old =
    case old of
        Evergreen.V3.Pages.Lists.Edit.ListId_.ListNameChanged p0 ->
            Evergreen.V4.Pages.Lists.Edit.ListId_.ListNameChanged p0

        Evergreen.V3.Pages.Lists.Edit.ListId_.UpdateListButtonClicked ->
            Evergreen.V4.Pages.Lists.Edit.ListId_.UpdateListButtonClicked

        Evergreen.V3.Pages.Lists.Edit.ListId_.GotTimeForUpdateList p0 ->
            Evergreen.V4.Pages.Lists.Edit.ListId_.GotTimeForUpdateList p0


migrate_Pages_Lists_Id__CreateItem_Model : Evergreen.V3.Pages.Lists.Id_.CreateItem.Model -> Evergreen.V4.Pages.Lists.Id_.CreateItem.Model
migrate_Pages_Lists_Id__CreateItem_Model old =
    { listId = old.listId
    , itemName = old.itemName
    , itemDescription = old.itemDescription
    , itemPriority = old.itemPriority |> migrate_ItemPriority_ItemPriority
    , error = old.error
    }


migrate_Pages_Lists_Id__CreateItem_Msg : Evergreen.V3.Pages.Lists.Id_.CreateItem.Msg -> Evergreen.V4.Pages.Lists.Id_.CreateItem.Msg
migrate_Pages_Lists_Id__CreateItem_Msg old =
    case old of
        Evergreen.V3.Pages.Lists.Id_.CreateItem.ItemNameChanged p0 ->
            Evergreen.V4.Pages.Lists.Id_.CreateItem.ItemNameChanged p0

        Evergreen.V3.Pages.Lists.Id_.CreateItem.ItemDescriptionChanged p0 ->
            Evergreen.V4.Pages.Lists.Id_.CreateItem.ItemDescriptionChanged p0

        Evergreen.V3.Pages.Lists.Id_.CreateItem.CreateItemButtonClicked ->
            Evergreen.V4.Pages.Lists.Id_.CreateItem.CreateItemButtonClicked

        Evergreen.V3.Pages.Lists.Id_.CreateItem.GotTimeForCreateItem p0 ->
            Evergreen.V4.Pages.Lists.Id_.CreateItem.GotTimeForCreateItem p0

        Evergreen.V3.Pages.Lists.Id_.CreateItem.ItemPriorityChanged p0 ->
            Evergreen.V4.Pages.Lists.Id_.CreateItem.ItemPriorityChanged p0


migrate_Pages_Lists_ListId__Edit_ItemId__Model : Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.Model -> Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.Model
migrate_Pages_Lists_ListId__Edit_ItemId__Model old =
    { itemName = old.itemName
    , initialItemName = old.initialItemName
    , itemChecked = old.itemChecked
    , initialItemChecked = old.initialItemChecked
    , itemPriority = old.itemPriority |> migrate_ItemPriority_ItemPriority
    , initialItemPriority = old.initialItemPriority |> migrate_ItemPriority_ItemPriority
    , itemDescription = old.itemDescription
    , initialItemDescription = old.initialItemDescription
    , listId = old.listId
    , itemId = old.itemId
    , createdAt = old.createdAt
    , lastUpdatedAt = old.lastUpdatedAt
    , numberOfUpdates = old.numberOfUpdates
    }


migrate_Pages_Lists_ListId__Edit_ItemId__Msg : Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.Msg -> Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.Msg
migrate_Pages_Lists_ListId__Edit_ItemId__Msg old =
    case old of
        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.SaveClicked ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.SaveClicked

        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.NameChanged p0 ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.NameChanged p0

        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.DoneClicked p0 ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.DoneClicked p0

        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.GotTimeForUpdatedItem p0 ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.GotTimeForUpdatedItem p0

        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.ItemPriorityChanged p0 ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.ItemPriorityChanged p0

        Evergreen.V3.Pages.Lists.ListId_.Edit.ItemId_.ItemDescriptionChanged p0 ->
            Evergreen.V4.Pages.Lists.ListId_.Edit.ItemId_.ItemDescriptionChanged p0


migrate_Pages_Lists_ListId__Model : Evergreen.V3.Pages.Lists.ListId_.Model -> Evergreen.V4.Pages.Lists.ListId_.Model
migrate_Pages_Lists_ListId__Model old =
    { listId = old.listId
    , listName = old.listName
    , currentTime = Time.millisToPosix 0
    , showDoneAfter = 1000 * 60 * 60 * 2
    }


migrate_Pages_Lists_ListId__Msg : Evergreen.V3.Pages.Lists.ListId_.Msg -> Evergreen.V4.Pages.Lists.ListId_.Msg
migrate_Pages_Lists_ListId__Msg old =
    case old of
        Evergreen.V3.Pages.Lists.ListId_.ItemCheckedToggled p0 p1 ->
            Evergreen.V4.Pages.Lists.ListId_.ItemCheckedToggled p0 p1

        Evergreen.V3.Pages.Lists.ListId_.GotTimeForItemCheckedToggled p0 p1 p2 ->
            Evergreen.V4.Pages.Lists.ListId_.GotTimeForItemCheckedToggled p0 p1 p2

        Evergreen.V3.Pages.Lists.ListId_.AddItemClicked ->
            Evergreen.V4.Pages.Lists.ListId_.AddItemClicked


migrate_Pages_Lists_Model : Evergreen.V3.Pages.Lists.Model -> Evergreen.V4.Pages.Lists.Model
migrate_Pages_Lists_Model old =
    old


migrate_Pages_Lists_Msg : Evergreen.V3.Pages.Lists.Msg -> Evergreen.V4.Pages.Lists.Msg
migrate_Pages_Lists_Msg old =
    case old of
        Evergreen.V3.Pages.Lists.CreateDummyList ->
            Evergreen.V4.Pages.Lists.CreateDummyList

        Evergreen.V3.Pages.Lists.CreatNewListClicked ->
            Evergreen.V4.Pages.Lists.CreatNewListClicked


migrate_Pages_Manual_Model : Evergreen.V3.Pages.Manual.Model -> Evergreen.V4.Pages.Manual.Model
migrate_Pages_Manual_Model old =
    old


migrate_Pages_Manual_Msg : Evergreen.V3.Pages.Manual.Msg -> Evergreen.V4.Pages.Manual.Msg
migrate_Pages_Manual_Msg old =
    case old of
        Evergreen.V3.Pages.Manual.NewUseridChanged p0 ->
            Evergreen.V4.Pages.Manual.NewUseridChanged p0

        Evergreen.V3.Pages.Manual.NewDeviceIdChanged p0 ->
            Evergreen.V4.Pages.Manual.NewDeviceIdChanged p0

        Evergreen.V3.Pages.Manual.NewUserNameChanged p0 ->
            Evergreen.V4.Pages.Manual.NewUserNameChanged p0

        Evergreen.V3.Pages.Manual.NewDeviceNameChanged p0 ->
            Evergreen.V4.Pages.Manual.NewDeviceNameChanged p0

        Evergreen.V3.Pages.Manual.CreateUserButtonClicked ->
            Evergreen.V4.Pages.Manual.CreateUserButtonClicked

        Evergreen.V3.Pages.Manual.AdminDataRequested ->
            Evergreen.V4.Pages.Manual.AdminDataRequested

        Evergreen.V3.Pages.Manual.ReconnectUser ->
            Evergreen.V4.Pages.Manual.ReconnectUser


migrate_Pages_NotFound__Model : Evergreen.V3.Pages.NotFound_.Model -> Evergreen.V4.Pages.NotFound_.Model
migrate_Pages_NotFound__Model old =
    old


migrate_Pages_NotFound__Msg : Evergreen.V3.Pages.NotFound_.Msg -> Evergreen.V4.Pages.NotFound_.Msg
migrate_Pages_NotFound__Msg old =
    case old of
        Evergreen.V3.Pages.NotFound_.NoOp ->
            Evergreen.V4.Pages.NotFound_.NoOp


migrate_Pages_Settings_Model : Evergreen.V3.Pages.Settings.Model -> Evergreen.V4.Pages.Settings.Model
migrate_Pages_Settings_Model old =
    old


migrate_Pages_Settings_Msg : Evergreen.V3.Pages.Settings.Msg -> Evergreen.V4.Pages.Settings.Msg
migrate_Pages_Settings_Msg old =
    case old of
        Evergreen.V3.Pages.Settings.NoOp ->
            Evergreen.V4.Pages.Settings.NoOp


migrate_Pages_SetupKnown_Model : Evergreen.V3.Pages.SetupKnown.Model -> Evergreen.V4.Pages.SetupKnown.Model
migrate_Pages_SetupKnown_Model old =
    old


migrate_Pages_SetupKnown_Msg : Evergreen.V3.Pages.SetupKnown.Msg -> Evergreen.V4.Pages.SetupKnown.Msg
migrate_Pages_SetupKnown_Msg old =
    case old of
        Evergreen.V3.Pages.SetupKnown.NoOp ->
            Evergreen.V4.Pages.SetupKnown.NoOp


migrate_Pages_Setup_Connect_Model : Evergreen.V3.Pages.Setup.Connect.Model -> Evergreen.V4.Pages.Setup.Connect.Model
migrate_Pages_Setup_Connect_Model old =
    old


migrate_Pages_Setup_Connect_Msg : Evergreen.V3.Pages.Setup.Connect.Msg -> Evergreen.V4.Pages.Setup.Connect.Msg
migrate_Pages_Setup_Connect_Msg old =
    case old of
        Evergreen.V3.Pages.Setup.Connect.CodeInputChanged p0 ->
            Evergreen.V4.Pages.Setup.Connect.CodeInputChanged p0

        Evergreen.V3.Pages.Setup.Connect.DeviceNameChanged p0 ->
            Evergreen.V4.Pages.Setup.Connect.DeviceNameChanged p0

        Evergreen.V3.Pages.Setup.Connect.OkButtonClicked ->
            Evergreen.V4.Pages.Setup.Connect.OkButtonClicked


migrate_Pages_Setup_Model : Evergreen.V3.Pages.Setup.Model -> Evergreen.V4.Pages.Setup.Model
migrate_Pages_Setup_Model old =
    old


migrate_Pages_Setup_Msg : Evergreen.V3.Pages.Setup.Msg -> Evergreen.V4.Pages.Setup.Msg
migrate_Pages_Setup_Msg old =
    case old of
        Evergreen.V3.Pages.Setup.CreateNewAccount ->
            Evergreen.V4.Pages.Setup.CreateNewAccount

        Evergreen.V3.Pages.Setup.ConnectExistingAccount ->
            Evergreen.V4.Pages.Setup.ConnectExistingAccount

        Evergreen.V3.Pages.Setup.Logout ->
            Evergreen.V4.Pages.Setup.Logout

        Evergreen.V3.Pages.Setup.ShowNewConnectionInfo ->
            Evergreen.V4.Pages.Setup.ShowNewConnectionInfo

        Evergreen.V3.Pages.Setup.GotMessageFromJs p0 ->
            Evergreen.V4.Pages.Setup.GotMessageFromJs p0


migrate_Pages_Setup_NewAccount_Model : Evergreen.V3.Pages.Setup.NewAccount.Model -> Evergreen.V4.Pages.Setup.NewAccount.Model
migrate_Pages_Setup_NewAccount_Model old =
    old


migrate_Pages_Setup_NewAccount_Msg : Evergreen.V3.Pages.Setup.NewAccount.Msg -> Evergreen.V4.Pages.Setup.NewAccount.Msg
migrate_Pages_Setup_NewAccount_Msg old =
    case old of
        Evergreen.V3.Pages.Setup.NewAccount.Create ->
            Evergreen.V4.Pages.Setup.NewAccount.Create

        Evergreen.V3.Pages.Setup.NewAccount.UsernameChanged p0 ->
            Evergreen.V4.Pages.Setup.NewAccount.UsernameChanged p0

        Evergreen.V3.Pages.Setup.NewAccount.DeviceNameChanged p0 ->
            Evergreen.V4.Pages.Setup.NewAccount.DeviceNameChanged p0


migrate_Route_Path_Path : Evergreen.V3.Route.Path.Path -> Evergreen.V4.Route.Path.Path
migrate_Route_Path_Path old =
    case old of
        Evergreen.V3.Route.Path.Home_ ->
            Evergreen.V4.Route.Path.Home_

        Evergreen.V3.Route.Path.Account ->
            Evergreen.V4.Route.Path.Account

        Evergreen.V3.Route.Path.Admin ->
            Evergreen.V4.Route.Path.Admin

        Evergreen.V3.Route.Path.Credits ->
            Evergreen.V4.Route.Path.Credits

        Evergreen.V3.Route.Path.Lists ->
            Evergreen.V4.Route.Path.Lists

        Evergreen.V3.Route.Path.Lists_Create ->
            Evergreen.V4.Route.Path.Lists_Create

        Evergreen.V3.Route.Path.Lists_Edit_ListId_ p0 ->
            Evergreen.V4.Route.Path.Lists_Edit_ListId_ p0

        Evergreen.V3.Route.Path.Lists_Id__CreateItem p0 ->
            Evergreen.V4.Route.Path.Lists_Id__CreateItem p0

        Evergreen.V3.Route.Path.Lists_ListId_ p0 ->
            Evergreen.V4.Route.Path.Lists_ListId_ p0

        Evergreen.V3.Route.Path.Lists_ListId__Edit_ItemId_ p0 ->
            Evergreen.V4.Route.Path.Lists_ListId__Edit_ItemId_ p0

        Evergreen.V3.Route.Path.Manual ->
            Evergreen.V4.Route.Path.Manual

        Evergreen.V3.Route.Path.Settings ->
            Evergreen.V4.Route.Path.Settings

        Evergreen.V3.Route.Path.Setup ->
            Evergreen.V4.Route.Path.Setup

        Evergreen.V3.Route.Path.Setup_Connect ->
            Evergreen.V4.Route.Path.Setup_Connect

        Evergreen.V3.Route.Path.Setup_NewAccount ->
            Evergreen.V4.Route.Path.Setup_NewAccount

        Evergreen.V3.Route.Path.SetupKnown ->
            Evergreen.V4.Route.Path.SetupKnown

        Evergreen.V3.Route.Path.NotFound_ ->
            Evergreen.V4.Route.Path.NotFound_


migrate_Shared_Model : Evergreen.V3.Shared.Model -> Evergreen.V4.Shared.Model
migrate_Shared_Model old =
    old |> migrate_Shared_Model_Model


migrate_Shared_Model_Model : Evergreen.V3.Shared.Model.Model -> Evergreen.V4.Shared.Model.Model
migrate_Shared_Model_Model old =
    { adminData =
        old.adminData
            |> (\rec ->
                    { userManagement = rec.userManagement |> migrate_UserManagement_Model
                    , backendSyncModel = rec.backendSyncModel |> migrate_Sync_BackendSyncModel
                    , subscriptions = rec.subscriptions |> migrate_Subscriptions_Model
                    }
               )
    , user = old.user |> Maybe.map migrate_Bridge_User
    , syncCode = old.syncCode
    , nextIds = old.nextIds
    , syncModel = old.syncModel |> migrate_Sync_FrontendSyncModel
    , state = old.state |> migrate_Event_State
    , menuOpen = old.menuOpen
    }


migrate_Shared_Msg : Evergreen.V3.Shared.Msg -> Evergreen.V4.Shared.Msg
migrate_Shared_Msg old =
    old |> migrate_Shared_Msg_Msg


migrate_Shared_Msg_Msg : Evergreen.V3.Shared.Msg.Msg -> Evergreen.V4.Shared.Msg.Msg
migrate_Shared_Msg_Msg old =
    case old of
        Evergreen.V3.Shared.Msg.GotAdminData p0 ->
            Evergreen.V4.Shared.Msg.GotAdminData
                { userManagement = p0.userManagement |> migrate_UserManagement_Model
                , backendSyncModel = p0.backendSyncModel |> migrate_Sync_BackendSyncModel
                , subscriptions = p0.subscriptions |> migrate_Subscriptions_Model
                }

        Evergreen.V3.Shared.Msg.NewUserCreated p0 ->
            Evergreen.V4.Shared.Msg.NewUserCreated (p0 |> migrate_Bridge_User)

        Evergreen.V3.Shared.Msg.AddEvent p0 ->
            Evergreen.V4.Shared.Msg.AddEvent (p0 |> migrate_Event_EventDefinition)

        Evergreen.V3.Shared.Msg.GotSyncCode p0 ->
            Evergreen.V4.Shared.Msg.GotSyncCode p0

        Evergreen.V3.Shared.Msg.GotUserData p0 ->
            Evergreen.V4.Shared.Msg.GotUserData p0

        Evergreen.V3.Shared.Msg.GotMessageFromJs p0 ->
            Evergreen.V4.Shared.Msg.GotMessageFromJs p0

        Evergreen.V3.Shared.Msg.ConnectionEstablished ->
            Evergreen.V4.Shared.Msg.ConnectionEstablished

        Evergreen.V3.Shared.Msg.GotSyncResult p0 ->
            Evergreen.V4.Shared.Msg.GotSyncResult
                { events = p0.events |> List.map migrate_Event_EventDefinition
                , lastSyncServerTime = p0.lastSyncServerTime
                }

        Evergreen.V3.Shared.Msg.SidebarToggled p0 ->
            Evergreen.V4.Shared.Msg.SidebarToggled p0


migrate_SortedEventList_Model : Evergreen.V3.SortedEventList.Model -> Evergreen.V4.SortedEventList.Model
migrate_SortedEventList_Model old =
    old |> Array.map migrate_Event_EventDefinition


migrate_Subscriptions_Model : Evergreen.V3.Subscriptions.Model -> Evergreen.V4.Subscriptions.Model
migrate_Subscriptions_Model old =
    old


migrate_Sync_BackendSyncModel : Evergreen.V3.Sync.BackendSyncModel -> Evergreen.V4.Sync.BackendSyncModel
migrate_Sync_BackendSyncModel old =
    { aggregates =
        old.aggregates
            |> Dict.map
                (\k ->
                    \rec ->
                        { events =
                            rec.events
                                |> Array.map
                                    (\rec1 ->
                                        { event = rec1.event |> migrate_Event_EventDefinition
                                        , serverTime = rec1.serverTime
                                        }
                                    )
                        }
                )
    }


migrate_Sync_FrontendSyncModel : Evergreen.V3.Sync.FrontendSyncModel -> Evergreen.V4.Sync.FrontendSyncModel
migrate_Sync_FrontendSyncModel old =
    { events = old.events |> migrate_SortedEventList_Model
    , lastSyncServerTime = old.lastSyncServerTime
    , unsyncedEventIds = old.unsyncedEventIds
    }


migrate_UserManagement_Model : Evergreen.V3.UserManagement.Model -> Evergreen.V4.UserManagement.Model
migrate_UserManagement_Model old =
    old


migrate_UserManagement_UserOnDeviceData : Evergreen.V3.UserManagement.UserOnDeviceData -> Evergreen.V4.UserManagement.UserOnDeviceData
migrate_UserManagement_UserOnDeviceData old =
    old
