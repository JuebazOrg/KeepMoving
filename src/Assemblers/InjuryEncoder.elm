module Assemblers.InjuryEncoder exposing (..)

import Assemblers.IdEncoder exposing (idEncoder)
import Date
import Domain.Injury exposing (Injury, InjuryType(..), NewInjury)
import Domain.Regions exposing (..)
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
                , ( "side", EncodeExtra.maybe Encode.string (Maybe.map fromSide injury.bodyRegion.side) )
                ]
          )
        , ( "startDate", Encode.string <| Date.toIsoString injury.startDate )
        , ( "endDate", Encode.string <| Date.toIsoString injury.startDate )
        , ( "how", Encode.string injury.how )
        , ( "injuryType", Encode.string <| injuryTypeToString injury.injuryType )
        ]


encodeNew : NewInjury -> Encode.Value
encodeNew injury =
    Encode.object
        [ ( "description", Encode.string injury.description )
        , ( "location", Encode.string injury.location )
        , ( "bodyRegion"
          , Encode.object
                [ ( "region", Encode.string <| fromRegion injury.bodyRegion.region ) -- todo: fct to encode dans encoder
                , ( "side", EncodeExtra.maybe Encode.string (Maybe.map fromSide injury.bodyRegion.side) ) -- todo fct encode dans encoder
                ]
          )
        , ( "startDate", Encode.string <| Date.toIsoString injury.startDate )
        , ( "endDate", Encode.string <| Date.toIsoString injury.startDate )
        , ( "how", Encode.string injury.how )
        , ( "injuryType", Encode.string <| injuryTypeToString injury.injuryType )
        ]


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
