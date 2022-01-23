module Event exposing (..)

import Date as Date exposing (Date)
import Time exposing (Month(..))


type alias DayEvent =
    { name : String
    , description : String
    , date : Date
    }



fakeEvents : List DayEvent
fakeEvents =
    [ { name = "Event1"
      , date = Date.fromCalendarDate 2022 Jan 3
      , description = "blablablabal"
      }
    , { name = "Event2"
      , date = Date.fromCalendarDate 2022 Feb 9
      , description = "blablablabal"
      }
    ]


isEventOnDate : Date -> DayEvent -> Bool 
isEventOnDate date event = 
    date == event.date