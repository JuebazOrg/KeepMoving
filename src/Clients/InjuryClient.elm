module Clients.InjuryClient exposing (..)

import Assemblers.Decoder.InjuryDecoder as InjuryDecoder
import Assemblers.Encoder.InjuryEncoder as InjuryEncoder
import Clients.Client exposing (Client, baseRoute, buildErrorMessage)
import Domain.Injury exposing (Injury, NewInjury)
import Http
import Json.Decode as Decode


client : Client
client =
    { baseRoute = baseRoute
    , route = "injuries/"
    , defaultErrorMessage = buildErrorMessage
    }


injuryPath : String -> String
injuryPath id =
    client.route ++ id


getInjuries : (Result Http.Error (List Injury) -> msg) -> Cmd msg
getInjuries onResult =
    Http.get
        { url = client.baseRoute ++ client.route
        , expect =
            Decode.list InjuryDecoder.decode
                |> Http.expectJson onResult
        }


getInjury : String -> (Result Http.Error Injury -> msg) -> Cmd msg
getInjury id onResult =
    Http.get
        { url = client.baseRoute ++ client.route ++ id
        , expect =
            InjuryDecoder.decode
                |> Http.expectJson onResult
        }


createInjury : NewInjury -> (Result Http.Error () -> msg) -> Cmd msg
createInjury injury onResult =
    Http.post
        { url = client.baseRoute ++ client.route
        , body = Http.jsonBody (InjuryEncoder.encodeNew injury)
        , expect = Http.expectWhatever onResult
        }


updateInjury : Injury -> (Result Http.Error Injury -> msg) -> Cmd msg
updateInjury injury onResult =
    Http.request
        { method = "PUT"
        , headers = []
        , url = client.baseRoute ++ client.route ++ injury.id
        , body = Http.jsonBody (InjuryEncoder.encode injury)
        , expect =
            InjuryDecoder.decode
                |> Http.expectJson onResult
        , timeout = Nothing
        , tracker = Nothing
        }
