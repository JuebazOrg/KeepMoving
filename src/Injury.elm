module Injury exposing (Injury)

import Date exposing (Date)
import Regions exposing (BodyRegion)


type alias Injury =
    { description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date
    }
