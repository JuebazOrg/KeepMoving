module Injury exposing (Injury)

import Regions exposing (BodyRegion)


type alias Injury =
    { description : String
    , bodyRegion : BodyRegion
    , location : String
    }
