module Domain.Injury exposing (..)

import Date exposing (Date)
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Regions exposing (BodyRegion, Region(..))
import Time exposing (Month(..))


type alias Injury =
    { id : String
    , description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date
    , endDate : Maybe Date
    , how : String
    , injuryType : InjuryType
    , checkPoints : List CheckPoint
    }


type alias NewInjury =
    { description : String
    , bodyRegion : BodyRegion
    , location : String
    , startDate : Date
    , endDate : Maybe Date
    , how : String
    , injuryType : InjuryType
    , checkPoints : List CheckPoint -- to be initialise by backend ?
    }


type InjuryType
    = Bruises
    | Dislocation
    | Fracture
    | Sprains --ligaments
    | Strains --tendon ou muscle
    | OtherInjuryType -- String type constructor


injuryTypes : List InjuryType
injuryTypes =
    [ Bruises
    , Dislocation
    , Fracture
    , Sprains
    , Strains
    , OtherInjuryType
    ]


isActive : Injury -> Bool
isActive injury =
    case injury.endDate of
        Just _ ->
            False

        Nothing ->
            True


injuryTypeToString :
    InjuryType
    -> String -- package formatter
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

        OtherInjuryType ->
            "Other"
