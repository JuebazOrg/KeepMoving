module Style exposing (..)

import Color as C
import Css exposing (..)


type EventStyle
    = EndDate
    | StartDate
    | Middle
    | DayEvent


event : EventStyle -> Color -> Style
event eventStyle eventColor =
    batch
        [ padding (px 2)
        , marginBottom (px 2)
        , height spacing.small
        , backgroundColor eventColor
        , cursor pointer
        , overflow hidden
        , textOverflow ellipsis
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


iconStyle : Style
iconStyle =
    batch
        [ fontSize (Css.em 2)
        , hover [ color C.grey ]
        , cursor pointer
        ]


type alias Spacing a =
    { xsmall : LengthOrAuto a
    , small : LengthOrAuto a
    , medium : LengthOrAuto a
    , large : LengthOrAuto a
    , xlarge : LengthOrAuto a
    , xxlarge : LengthOrAuto a
    , xxxlarge : LengthOrAuto a
    }


spacing : Spacing Em
spacing =
    { xsmall = Css.em 0.5
    , small = Css.em 1
    , medium = Css.em 2
    , large = Css.em 3
    , xlarge = Css.em 5
    , xxlarge = Css.em 7
    , xxxlarge = Css.em 10
    }
