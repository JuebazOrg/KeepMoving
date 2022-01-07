module Injury exposing (..)

import Date exposing (Date)
import Regions exposing (BodyRegion)


type InjuryType
    = Bruises
    | Dislocation
    | Fracture
    | Sprains --ligaments
    | Strains --tendon ou muscle
    | Other


type alias Injury =
    { description : String
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

