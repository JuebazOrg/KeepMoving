module Navigation.Route exposing (..)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Injuries
    | Injury String
    | NewInjury
    | EditInjury String
    | Account


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
        , map Injury (s "injuries" </> string)
        , map NewInjury (s "new")
        , map EditInjury (s "injuries" </> string </> s "edit")
        , map Account (s "account")
        ]


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Injuries ->
            "/injuries"

        Injury id ->
            "/injuries/" ++ id

        NewInjury ->
            "/new"

        EditInjury id ->
            "/injuries/" ++ id ++ "/edit"

        Account ->
            "/account"
