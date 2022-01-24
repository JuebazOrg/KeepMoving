module Event exposing (..)

import Color as C
import Css exposing (..)
import Date as Date exposing (Date)
import Time exposing (Month(..))


type Event
    = Multi MultiDayEvent
    | Single DayEvent


type alias DayEvent =
    { name : String
    , color : Color
    , description : String
    , date : Date
    }


type alias MultiDayEvent =
    { name : String
    , color : Color
    , description : String
    , startDate : Date
    , endDate : Date
    }


fakeEvents : List Event
fakeEvents =
    fakeMultiDayEvents
        |> List.map (\e -> Multi e)
        |> List.append (List.map (\e -> Single e) fakeDayEvents)


fakeDayEvents : List DayEvent
fakeDayEvents =
    [ { name = "Event1"
      , date = Date.fromCalendarDate 2022 Jan 3
      , description = "blablablabal"
      , color = C.color11
      }
    , { name = "Event1.1"
      , date = Date.fromCalendarDate 2022 Jan 3
      , description = "blablablabal"
      , color = C.color10
      }
    , { name = "Event2"
      , date = Date.fromCalendarDate 2022 Feb 9
      , description = "blablablabal"
      , color = C.color12
      }
    ]


fakeMultiDayEvents : List MultiDayEvent
fakeMultiDayEvents =
    [ { name = "Event3"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      , color = C.color5
      }
    , { name = "Event3.2"
      , startDate = Date.fromCalendarDate 2022 Jan 3
      , endDate = Date.fromCalendarDate 2022 Jan 4
      , description = "blablablabal"
      , color = C.color18
      }
    , { name = "Event4"
      , startDate = Date.fromCalendarDate 2022 Feb 9
      , endDate = Date.fromCalendarDate 2022 Feb 24
      , description = "blablablabal"
      , color = C.color8
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
