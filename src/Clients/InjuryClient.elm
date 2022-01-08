module Clients.InjuryClient exposing (..)

import Assemblers.InjuryDecoder as InjuryDecoder
import Assemblers.InjuryEncoder as InjuryEncoder
import Clients.Client exposing (Client, baseRoute, buildErrorMessage)
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


getInjury : Int -> (Result Http.Error Injury -> msg) -> Cmd msg
getInjury id onResult =
    Http.get
        { url = client.baseRoute ++ client.route ++ "/" ++ String.fromInt id
        , expect =
            InjuryDecoder.decode
                |> Http.expectJson onResult
        }


createInjury : Injury -> (Result Http.Error () -> msg) -> Cmd msg
createInjury injury onResult =
    Http.post
        { url = client.baseRoute ++ client.route
        , body = Http.jsonBody (InjuryEncoder.encode injury)
        , expect = Http.expectWhatever onResult
        }
