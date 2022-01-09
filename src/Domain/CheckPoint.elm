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
