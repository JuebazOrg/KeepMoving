module Assemblers.Decoder.DateDecoder exposing (..)

import Date as Date
import Json.Decode as D


dateDecoder : D.Decoder Date.Date
dateDecoder =
    D.string
        |> D.andThen
            (\str ->
                case Date.fromIsoString str of
                    Err err ->
                        D.fail err

                    Ok date ->
                        D.succeed date
            )
