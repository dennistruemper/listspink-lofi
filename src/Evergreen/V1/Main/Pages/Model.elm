module Evergreen.V1.Main.Pages.Model exposing (..)

import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Lists
import Evergreen.V1.Pages.Manual
import Evergreen.V1.Pages.NotFound_
import Evergreen.V1.Pages.Setup
import Evergreen.V1.Pages.Setup.Connect
import Evergreen.V1.Pages.Setup.NewAccount
import Evergreen.V1.Pages.SetupKnown


type Model
    = Home_ Evergreen.V1.Pages.Home_.Model
    | Admin Evergreen.V1.Pages.Admin.Model
    | Lists Evergreen.V1.Pages.Lists.Model
    | Manual Evergreen.V1.Pages.Manual.Model
    | Setup Evergreen.V1.Pages.Setup.Model
    | Setup_Connect Evergreen.V1.Pages.Setup.Connect.Model
    | Setup_NewAccount Evergreen.V1.Pages.Setup.NewAccount.Model
    | SetupKnown Evergreen.V1.Pages.SetupKnown.Model
    | NotFound_ Evergreen.V1.Pages.NotFound_.Model
    | Redirecting_
    | Loading_
