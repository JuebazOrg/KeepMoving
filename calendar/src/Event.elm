module Event exposing (..)

import Date as Date exposing (Date)
import Time exposing (Month(..))


type alias DayEvent =
    { name : String
    , description : String
    , date : Date
    }


type alias MultiDayEvent =
    { name : String
    , description : String
    , startDate : Date
    , endDate : Date
    }


fakeEvents : List DayEvent
fakeEvents =
    [ { name = "Event1"
      , date = Date.fromCalendarDate 2022 Jan 3
      , description = "blablablabal"
      }
    , { name = "Event1.1"
      , date = Date.fromCalendarDate 2022 Jan 3
      , description = "blablablabal"
      }
    , { name = "Event2"
      , date = Date.fromCalendarDate 2022 Feb 9
      , description = "blablablabal"
      }
    ]


fakeMultiDayEvents : List MultiDayEvent
fakeMultiDayEvents =
    [ { name = "Event3"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      }
    , { name = "Event3.2"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      }
    , { name = "Event4"
      , startDate = Date.fromCalendarDate 2022 Feb 9
      , endDate = Date.fromCalendarDate 2022 Feb 24
      , description = "blablablabal"
      }
    ]


isEventOnDate : Date -> DayEvent -> Bool
isEventOnDate date event =
    date == event.date


isEventBetweenDate : Date -> MultiDayEvent -> Bool
isEventBetweenDate date event =
    Date.isBetween event.startDate event.endDate date


isEndDate : Date -> MultiDayEvent -> Bool
isEndDate date event =
    date == event.endDate


isStartDate : Date -> MultiDayEvent -> Bool
isStartDate date event =
    date == event.startDate
