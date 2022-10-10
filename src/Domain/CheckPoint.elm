module Domain.CheckPoint exposing (..)

import Bulma.Styled.Layout exposing (Level)
import Date exposing (Date)
import Id exposing (Id)


type alias CheckPoint =
    { id : String, date : Date, comment : String, painLevel : Int, trend : Trend }


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


levels : List Int
levels =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
