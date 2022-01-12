module Util.Date exposing (..)

import Date as D


orderByMostRecent : List D.Date -> List D.Date
orderByMostRecent dates =
    List.sortWith D.compare dates


orderByLeastRecent : List D.Date -> List D.Date
orderByLeastRecent dates =
    dates
        |> List.sortWith D.compare
        |> List.reverse


formatMMDY : D.Date -> String 
formatMMDY date = 
    D.format "MMM d, y" date

formatMMMMDY : D.Date -> String 
formatMMMMDY date = 
    D.format "MMMM d, y" date

