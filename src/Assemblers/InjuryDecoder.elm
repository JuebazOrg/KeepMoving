module Assemblers.InjuryDecoder exposing (decode)

import Injury exposing (..)
import Json.Decode as D
import Regions exposing (BodyRegion, Region(..), Side(..))


decode : D.Decoder Injury
decode =
    D.map3 Injury
        (D.field "description" D.string)
        (D.field "bodyRegion" bodyRegionDecoder)
        (D.field "location" D.string)


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
