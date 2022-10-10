module Id exposing (..)

import Url.Parser exposing (Parser, custom)


type Id
    = Id String


idParser : Parser (Id -> a) a
idParser =
    custom "ID" <|
        \postId ->
            Maybe.map Id (Just postId)
