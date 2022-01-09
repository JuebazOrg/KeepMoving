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
