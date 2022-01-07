module Assemblers.InjuryDecoder exposing (decode)

import Date exposing (..)
import Injury exposing (..)
import Json.Decode as D
import Regions exposing (BodyRegion, Region(..), Side(..))


decode : D.Decoder Injury
decode =
    D.map4 Injury
        (D.field "description" D.string)
        (D.field "bodyRegion" bodyRegionDecoder)
        (D.field "location" D.string)
        (D.field "startDate" dateDecoder)


bodyRegionDecoder : D.Decoder BodyRegion
bodyRegionDecoder =
    D.map2 BodyRegion
        (D.field "region" <| regionDecoder)
        (D.field "side" <| sideDecoder)


regionDecoder : D.Decoder Region
regionDecoder =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "Head" ->
                        D.succeed Head

                    "Leg" ->
                        D.succeed Leg

                    "Arm" ->
                        D.succeed Arm

                    "Wrist" ->
                        D.succeed Wrist

                    "Feet" ->
                        D.succeed Feet

                    _ ->
                        D.fail <| "Unknown region: "
            )


sideDecoder : D.Decoder (Maybe Side)
sideDecoder =
    D.nullable
        (D.string
            |> D.andThen
                (\str ->
                    case str of
                        "Left" ->
                            D.succeed Left

                        "Right" ->
                            D.succeed Right

                        "Middle" ->
                            D.succeed Middle

                        _ ->
                            D.fail "unknow side"
                )
        )


dateDecoder : D.Decoder Date
dateDecoder =
    D.string
        |> D.andThen
            (\str ->
                case Date.fromIsoString str of
                    Err err ->
                        D.fail err

                    Ok date ->
                        D.succeed date
            )
