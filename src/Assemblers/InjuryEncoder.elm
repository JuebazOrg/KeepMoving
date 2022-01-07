module Assemblers.InjuryEncoder exposing (..)

import Date
import Injury exposing (..)
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import Regions exposing (..)


encode : Injury -> Encode.Value
encode injury =
    Encode.object
        [ ( "description", Encode.string injury.description )
        , ( "location", Encode.string injury.location )
        , ( "bodyRegion"
          , Encode.object
                [ ( "region", Encode.string <| fromRegion injury.bodyRegion.region )
                , ( "side", EncodeExtra.maybe Encode.string (Maybe.map fromSide injury.bodyRegion.side) )
                ]
          )
        , ( "startDate", Encode.string <| Date.toIsoString injury.startDate )
        ]
