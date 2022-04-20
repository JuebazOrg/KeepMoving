module Assemblers.Encoder.InjuryEncoder exposing (..)

import Assemblers.Encoder.CheckPointEncoder as CheckPointEncoder
import Assemblers.Encoder.IdEncoder exposing (idEncoder)
import Date exposing (Date)
import Domain.Injury exposing (Injury, InjuryType(..), NewInjury)
import Domain.Regions as Region exposing (..)
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra


encode : Injury -> Encode.Value
encode injury =
    Encode.object
        [ ( "id", Encode.int <| idEncoder injury.id )
        , ( "description", Encode.string injury.description )
        , ( "location", Encode.string injury.location )
        , ( "bodyRegion"
          , Encode.object
                [ ( "region", Encode.string <| fromRegion injury.bodyRegion.region )
                , ( "side", EncodeExtra.maybe Encode.string (Maybe.map Region.sideToString injury.bodyRegion.side) )
                ]
          )
        , ( "startDate", encodeDate injury.startDate )
        , ( "endDate", EncodeExtra.maybe encodeDate injury.endDate )
        , ( "how", Encode.string injury.how )
        , ( "injuryType", Encode.string <| injuryTypeToString injury.injuryType )
        , ( "checkPoints", Encode.list CheckPointEncoder.encode injury.checkPoints )
        ]


encodeNew : NewInjury -> Encode.Value
encodeNew injury =
    Encode.object
        [ ( "description", Encode.string injury.description )
        , ( "location", Encode.string injury.location )
        , ( "bodyRegion"
          , Encode.object
                [ ( "region", encodeRegion injury.bodyRegion.region ) -- todo:  mettre dans un bodyRegion encoder
                , ( "side"
                  , injury.bodyRegion.side
                        |> Maybe.map Region.sideToString
                        |> EncodeExtra.maybe Encode.string
                  )
                ]
          )
        , ( "startDate", encodeDate injury.startDate )
        , ( "endDate", EncodeExtra.maybe encodeDate injury.endDate )
        , ( "how", Encode.string injury.how )
        , ( "injuryType", Encode.string <| injuryTypeToString injury.injuryType )
        , ( "checkPoints", Encode.list CheckPointEncoder.encode injury.checkPoints )
        ]


encodeDate : Date -> Encode.Value
encodeDate date =
    Encode.string (Date.toIsoString date)


encodeRegion : Region -> Encode.Value
encodeRegion region =
    let
        string =
            case region of
                Leg ->
                    "Leg"

                Arm ->
                    "Arm"

                Neck ->
                    "Neck"

                Hand ->
                    "Hand"

                Wrist ->
                    "Wrist"

                UpperBack ->
                    "Upper back"

                MiddleBack ->
                    "Middle back"

                LowerBack ->
                    "Lower back"

                Feet ->
                    "Feet"

                Head ->
                    "Head"

                Other ->
                    "Other"
    in
    Encode.string string


injuryTypeToString : InjuryType -> String
injuryTypeToString injuryType =
    case injuryType of
        Bruises ->
            "Bruises"

        Dislocation ->
            "Dislocation"

        Fracture ->
            "Facture"

        Sprains ->
            "Sprains"

        Strains ->
            "Strains"

        OtherInjuryType ->
            "Other"
