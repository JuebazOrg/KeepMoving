module Domain.Injury exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Dict.Extra as Dict
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Regions exposing (BodyRegion, Region(..))
import Id exposing (Id)
import Time exposing (Month(..))


type InjuryType
    = Bruises
    | Dislocation
    | Fracture
    | Sprains --ligaments
    | Strains --tendon ou muscle
    | OtherInjuryType


type alias Injury =
    { id : Id
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

        OtherInjuryType ->
            "Other"


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


injuriesByYear : List Injury -> Dict Int (List Injury)
injuriesByYear injuries =
    injuries
        |> List.map
            (\i ->
                { date = Date.year i.startDate, injuries = [ i ] }
            )
        |> Dict.groupBy (\i -> i.date)
        |> Dict.map (\_ -> List.map .injuries)
        |> Dict.map (\_ -> List.concat)

