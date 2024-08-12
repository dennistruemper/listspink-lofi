module Evergreen.V1.Main.Pages.Msg exposing (..)

import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Lists
import Evergreen.V1.Pages.Manual
import Evergreen.V1.Pages.NotFound_
import Evergreen.V1.Pages.Setup
import Evergreen.V1.Pages.Setup.Connect
import Evergreen.V1.Pages.Setup.NewAccount
import Evergreen.V1.Pages.SetupKnown


type Msg
    = Home_ Evergreen.V1.Pages.Home_.Msg
    | Admin Evergreen.V1.Pages.Admin.Msg
    | Lists Evergreen.V1.Pages.Lists.Msg
    | Manual Evergreen.V1.Pages.Manual.Msg
    | Setup Evergreen.V1.Pages.Setup.Msg
    | Setup_Connect Evergreen.V1.Pages.Setup.Connect.Msg
    | Setup_NewAccount Evergreen.V1.Pages.Setup.NewAccount.Msg
    | SetupKnown Evergreen.V1.Pages.SetupKnown.Msg
    | NotFound_ Evergreen.V1.Pages.NotFound_.Msg
