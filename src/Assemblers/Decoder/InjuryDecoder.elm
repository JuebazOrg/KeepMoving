module Assemblers.Decoder.InjuryDecoder exposing (decode)

import Assemblers.Decoder.CheckPointDecoder as CheckPointDecoder
import Assemblers.Decoder.DateDecoder exposing (dateDecoder)
import Assemblers.Decoder.IdDecoder exposing (idDecoder)
import Date exposing (..)
import Domain.Injury exposing (..)
import Domain.Regions exposing (BodyRegion, Region(..), Side(..))
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)


decode : D.Decoder Injury
decode =
    D.succeed Injury
        |> required "id" idDecoder
        |> required "description" D.string
        |> required "bodyRegion" bodyRegionDecoder
        |> required "location" D.string
        |> required "startDate" dateDecoder
        |> required "endDate" (D.nullable dateDecoder)
        |> required "how" D.string
        |> required "injuryType" injuryTypeDecoder
        |> required "checkPoints" (D.list CheckPointDecoder.decode)


injuryTypeDecoder : D.Decoder InjuryType
injuryTypeDecoder =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "Bruises" ->
                        D.succeed Bruises

                    "Dislocation" ->
                        D.succeed Dislocation

                    "Fracture" ->
                        D.succeed Fracture

                    "Sprains" ->
                        D.succeed Sprains

                    "Strains" ->
                        D.succeed Strains

                    "Other" ->
                        D.succeed OtherInjuryType

                    _ ->
                        D.fail "unknow injury type "
            )


bodyRegionDecoder : D.Decoder BodyRegion
bodyRegionDecoder =
    D.map2 BodyRegion
        (D.field "region" regionDecoder)
        (D.field "side" sideDecoder)


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

                    "Hand" ->
                        D.succeed Hand

                    "Neck" ->
                        D.succeed Neck

                    "MiddleBack" ->
                        D.succeed MiddleBack

                    "LowerBack" ->
                        D.succeed LowerBack

                    "UpperBack" ->
                        D.succeed UpperBack

                    "Other" ->
                        D.succeed Other

                    _ ->
                        D.fail "Unknown region: "
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
