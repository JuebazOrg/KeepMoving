module Mock.InjuryMock exposing (..)

import Injury exposing (Injury)
import Regions exposing (Region(..), Side(..))


anInjury : Injury
anInjury =
    { description = "chute en snow dans la neige, coupure au genoux gauche", location = "avant-bras", bodyRegion = { region = Arm, side = Just Right } }


anInjury2 : Injury
anInjury2 =
    { description = "chute en snow dans la neige, coupure au genoux gauche", location = "omoplate gauche", bodyRegion = { region = UpperBack, side = Nothing } }
