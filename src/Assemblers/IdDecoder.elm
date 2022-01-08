module Assemblers.IdDecoder exposing (..)

import Id exposing (Id(..))
import Json.Decode as D exposing (Decoder)


idDecoder : Decoder Id
idDecoder =
    D.map Id D.int
