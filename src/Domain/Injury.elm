module Domain.Injury exposing (..)

import Date exposing (Date)
import Domain.Regions exposing (BodyRegion, Region(..))
import Id exposing (Id)
import Time exposing (Month(..))


type InjuryType
    = Bruises
    | Dislocation
    | Fracture
    | Sprains --ligaments
    | Strains --tendon ou muscle
    | Other


type alias Injury =
    { id : Id
    , description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date
    , endDate : Date
    , how : String
    , injuryType : InjuryType
    }


type alias NewInjury =
    { description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date.Date
    , endDate : Date.Date
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


injuryTypes : List InjuryType
injuryTypes =
    [ Bruises
    , Dislocation
    , Fracture
    , Sprains
    , Strains
    , Other
    ]
