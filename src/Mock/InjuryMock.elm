module Mock.InjuryMock exposing (..)

import Injuries exposing (Injury)


anInjury : Injury
anInjury =
    { description = "chute en snow dans la neige, coupure au genoux gauche", region = "genoux gauche" }

anInjury2 : Injury
anInjury2 =
    { description = "chute en snow dans la neige, coupure au genoux gauche", region = "poignet droit" }
