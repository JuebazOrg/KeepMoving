module Clients.InjuryClient exposing (..)

import Clients.Client exposing (Client, baseRoute, buildErrorMessage)
import Decoders.InjuryDecoder as InjuryDecoder
import Http
import Injury exposing (Injury)
import Json.Decode as Decode


client : Client
client =
    { baseRoute = baseRoute
    , route = "injuries"
    , defaultErrorMessage = buildErrorMessage
    }


getInjuries : (Result Http.Error (List Injury) -> msg) -> Cmd msg
getInjuries onResult =
    Http.get
        { url = client.baseRoute ++ client.route
        , expect =
            Decode.list InjuryDecoder.decode
                |> Http.expectJson onResult
        }
