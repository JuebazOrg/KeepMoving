module Assemblers.IdEncoder exposing (..)

import Id exposing (Id(..), toString)


idEncoder : Id -> String
idEncoder id =
    toString id
