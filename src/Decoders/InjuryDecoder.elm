module Decoders.InjuryDecoder exposing (..)

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
        (D.field "region" <| fromRegion)
        (D.field "side" <| fromSide)


fromRegion : D.Decoder Region
fromRegion =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "Head" ->
                        D.succeed Head

                    "Leg" ->
                        D.succeed Leg

                    _ ->
                        D.fail <| "Unknown region: "
            )


fromSide : D.Decoder (Maybe Side)
fromSide =
    D.nullable sideDecoder


sideDecoder : D.Decoder Side
sideDecoder =
    D.string
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
