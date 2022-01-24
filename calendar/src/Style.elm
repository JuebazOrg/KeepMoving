module Style exposing (..)

import Color as C
import Css exposing (..)


type EventStyle
    = EndDate
    | StartDate
    | Middle
    | DayEvent


event :  EventStyle-> Color -> Style
event eventStyle eventColor=
    batch
        [ padding (px 2)
        , marginBottom (px 2)
        , backgroundColor eventColor
        , fontSize small
        , if eventStyle == Middle then
            color eventColor

          else if eventStyle == EndDate then
            color eventColor

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


fontStyle : Style
fontStyle =
    batch
        [ fontFamilies [ "Comfortaa" ]
        ]
