module Assemblers.IdEncoder exposing (..)

import Id exposing (Id(..), toInt)


idEncoder : Id -> Int
idEncoder id =
    toInt id
