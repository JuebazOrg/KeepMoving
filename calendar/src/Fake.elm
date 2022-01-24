module Fake exposing (..)

import Color as C
import Date as Date
import Event exposing (..)
import Time exposing (..)


fakeEvents : List Event
fakeEvents =
    [ { name = "Event3"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Just <| Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      , color = C.color5
      }
    , { name = "Event3.2"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Just <| Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      , color = C.color18
      }
    , { name = "Event4"
      , startDate = Date.fromCalendarDate 2022 Feb 9
      , endDate = Just <| Date.fromCalendarDate 2022 Feb 24
      , description = "blablablabal"
      , color = C.color8
      }
    , { name = "Event1"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Nothing
      , description = "blablablabal"
      , color = C.color1
      }
    , { name = "Event5"
      , startDate = Date.fromCalendarDate 2022 Jan 7
      , endDate = Nothing
      , description = "blablablabal"
      , color = C.color2
      }
    ]
