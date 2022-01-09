module Domain.CheckPoint exposing (..)

import Date exposing (Date)
import Id exposing (Id)


type alias CheckPoint =
    { id : Id, date : Date, comment : String, painLevel : Int, trend : Trend }


type alias NewCheckPoint =
    { date : Date, comment : String, painLevel : Int, trend : Trend }


type Trend
    = Better
    | Worst
    | Stable


trendToString : Trend -> String
trendToString trend =
    case trend of
        Better ->
            "Better"

        Worst ->
            "Worst"

        Stable ->
            "Stable"
