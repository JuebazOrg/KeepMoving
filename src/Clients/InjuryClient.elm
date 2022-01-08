module Clients.InjuryClient exposing (..)

import Assemblers.InjuryDecoder as InjuryDecoder
import Assemblers.InjuryEncoder as InjuryEncoder
import Clients.Client exposing (Client, baseRoute, buildErrorMessage)
import Domain.Injury exposing (Injury)
import Http
import Id as Id exposing (Id)
import Json.Decode as Decode


client : Client
client =
    { baseRoute = baseRoute
    , route = "injuries/"
    , defaultErrorMessage = buildErrorMessage
    }


injuryPath : Id -> String
injuryPath id =
    client.route ++ Id.toString id


getInjuries : (Result Http.Error (List Injury) -> msg) -> Cmd msg
getInjuries onResult =
    Http.get
        { url = client.baseRoute ++ client.route
        , expect =
            Decode.list InjuryDecoder.decode
                |> Http.expectJson onResult
        }


getInjury : Id -> (Result Http.Error Injury -> msg) -> Cmd msg
getInjury id onResult =
    Http.get
        { url = client.baseRoute ++ client.route ++ Id.toString id
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
