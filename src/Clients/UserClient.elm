module Clients.UserClient exposing (..)

import Assemblers.Decoder.UserDecoder as UserDecoder
import Clients.Client exposing (Client, baseRoute, buildErrorMessage)
import Domain.User exposing (User)
import Http


client : Client
client =
    { baseRoute = baseRoute
    , route = "user/"
    , defaultErrorMessage = buildErrorMessage
    }


getUser : (Result Http.Error User -> msg) -> Cmd msg
getUser onResult =
    Http.get
        { url = client.baseRoute ++ client.route
        , expect =
            UserDecoder.decode
                |> Http.expectJson onResult
        }
