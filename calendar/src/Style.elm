module Style exposing (..)

import Color as C
import Css exposing (..)


type EventStyle
    = EndDate
    | StartDate
    | Middle
    | DayEvent


event : EventStyle -> Style
event eventStyle =
    batch
        [ padding (px 2)
        , marginBottom (px 2)
        , backgroundColor C.blue
        , if eventStyle == Middle then
            color C.blue

          else if eventStyle == EndDate then
            color C.blue

          else
            color C.white
        , case eventStyle of
            StartDate ->
                borderRadius4 (px 2) (px 0) (px 0) (px 2)

            EndDate ->
                borderRadius4 (px 0) (px 2) (px 2) (px 0)

            DayEvent ->
                borderRadius (px 2)

            Middle ->
                borderRadius (px 0)
        ]


title : Style
title =
    batch
        [ fontFamilies [ "Comfortaa" ]
        , fontSize (px 30)
        ]
