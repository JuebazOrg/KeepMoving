module Event exposing (..)

import Css exposing (Color)
import Date as Date exposing (Date)
import Time exposing (Month(..))


type alias Event =
    { name : String
    , color : Color
    , description : String
    , startDate : Date
    , endDate : Maybe Date
    }


isEventOnDate : Date -> Event -> Bool
isEventOnDate date event =
    date == event.startDate


isEventBetweenDate : Date -> Event -> Bool
isEventBetweenDate date event =
  case event.endDate of 
    Nothing -> False 
    Just date2 -> Date.isBetween event.startDate date2 date


isEndDate : Date -> Event -> Bool
isEndDate date event =
    case event.endDate of 
    Nothing -> False 
    Just date2 -> date == date2
    


isStartDate : Date -> Event -> Bool
isStartDate date event =
    date == event.startDate
