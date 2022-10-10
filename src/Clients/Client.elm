module Clients.Client exposing (..)

import Http


baseRoute : String
baseRoute =
    "http://localhost:8000/"


type alias Client =
    { baseRoute : String
    , route : String
    , defaultErrorMessage : Http.Error -> String
    }


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message
