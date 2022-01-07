module Navigation.Route exposing (..)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Injuries


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Injuries top
        , map Injuries (s "injuries")
        ]
