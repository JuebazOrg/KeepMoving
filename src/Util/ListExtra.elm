module Util.ListExtra exposing (..)


applyIf : Bool -> (a -> a) -> a -> a
applyIf predicat fct value =
    if predicat then
        fct value

    else
        value
