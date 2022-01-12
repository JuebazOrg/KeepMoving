module Id exposing (..)

import Url.Parser exposing (Parser, custom)


type Id
    = Id Int


toString : Id -> String
toString id =
    String.fromInt
        (case id of
            Id i ->
                i
        )


toInt : Id -> Int
toInt id =
    case id of
        Id i ->
            i


idParser : Parser (Id -> a) a
idParser =
    custom "ID" <|
        \postId ->
            Maybe.map Id (String.toInt postId)


noId : Id
noId =
    Id -1
