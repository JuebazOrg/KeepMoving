module Mock.InjuryMock exposing (..)

import Injuries exposing (Injury)
import Regions exposing (Region(..), Side(..))


anInjury : Injury
anInjury =
    { description = "chute en snow dans la neige, coupure au genoux gauche", location = "avant-bras", region = { region = Arm, side = Just Right } }


anInjury2 : Injury
anInjury2 =
    { description = "chute en snow dans la neige, coupure au genoux gauche", location = "omoplate gauche", region = { region = UpperBack, side = Nothing } }
