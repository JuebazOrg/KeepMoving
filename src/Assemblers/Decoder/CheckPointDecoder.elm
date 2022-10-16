module Assemblers.Decoder.CheckPointDecoder exposing (..)

import Assemblers.Decoder.DateDecoder exposing (dateDecoder)
import Domain.CheckPoint exposing (CheckPoint, Trend(..))
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)


decode : D.Decoder CheckPoint
decode =
    D.succeed CheckPoint
        |> required "id" D.string
        |> required "date" dateDecoder
        |> required "comment" D.string
        |> required "painLevel" D.int
        |> required "trend" decodeTrend


decodeTrend : D.Decoder Trend
decodeTrend =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "better" ->
                        D.succeed Better

                    "worst" ->
                        D.succeed Worst

                    "stable" ->
                        D.succeed Stable

                    _ ->
                        D.fail "unknow trend"
            )
