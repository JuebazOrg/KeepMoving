module Injury exposing (..)

import Date exposing (Date)
import Regions exposing (BodyRegion, Region(..))
import Time exposing (Month(..))


type InjuryType
    = Bruises
    | Dislocation
    | Fracture
    | Sprains --ligaments
    | Strains --tendon ou muscle
    | Other


type alias Injury =
    { id : Int
    , description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date
    , endDate : Date
    , how : String
    , injuryType : InjuryType
    }


injuryTypeToString : InjuryType -> String
injuryTypeToString injuryType =
    case injuryType of
        Bruises ->
            "Bruise"

        Dislocation ->
            "Dislocation"

        Fracture ->
            "Facture"

        Sprains ->
            "Muscle or Tendon"

        Strains ->
            "Ligament"

        Other ->
            "Other"


empty : Injury
empty =
    { id = 0
    , description = ""
    , bodyRegion = { region = Head, side = Nothing }
    , location = ""
    , startDate = Date.fromCalendarDate 2020 Jan 20
    , endDate = Date.fromCalendarDate 2020 Jan 20
    , how = ""
    , injuryType = Other
    }
