module Assemblers.Decoder.UserDecoder exposing (..)

import Domain.User exposing (User)
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)


decode : D.Decoder User
decode =
    D.succeed User
        |> required "name" D.string
        |> required "email" D.string
