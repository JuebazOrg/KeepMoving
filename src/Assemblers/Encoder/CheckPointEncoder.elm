module Assemblers.Encoder.CheckPointEncoder exposing (..)

import Date exposing (Date)
import Domain.CheckPoint exposing (CheckPoint, Trend(..))
import Json.Encode as Encode


encode : CheckPoint -> Encode.Value
encode checkPoint =
    Encode.object
        [ ( "id", Encode.string checkPoint.id )
        , ( "date", encodeDate checkPoint.date )
        , ( "comment", Encode.string checkPoint.comment )
        , ( "painLevel", Encode.int checkPoint.painLevel )
        , ( "trend", encodeTrend checkPoint.trend )
        ]


encodeDate : Date -> Encode.Value
encodeDate date =
    Encode.string (Date.toIsoString date)


encodeTrend : Trend -> Encode.Value
encodeTrend trend =
    case trend of
        Better ->
            Encode.string "better"

        Worst ->
            Encode.string "worst"

        Stable ->
            Encode.string "stable"
