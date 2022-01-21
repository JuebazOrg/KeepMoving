module Util exposing (..)

import Time exposing (Month(..), Weekday(..))

daysOfWeekToString : Weekday -> String
daysOfWeekToString day =
    case day of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"


monthToString : Month -> String
monthToString month =
    case month of
        Jan ->
            "januar"

        Feb ->
            "februar"

        Mar ->
            "marts"

        Apr ->
            "april"

        May ->
            "maj"

        Jun ->
            "juni"

        Jul ->
            "juli"

        Aug ->
            "august"

        Sep ->
            "september"

        Oct ->
            "oktober"

        Nov ->
            "november"

        Dec ->
            "december"