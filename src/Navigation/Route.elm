module Navigation.Route exposing (..)

import Browser.Navigation as Nav
import Css exposing (nwResize)
import Id exposing (Id, idParser)
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Injuries
    | Injury Id
    | NewInjury
    | EditInjury Id
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
        , map Injury (s "injuries" </> idParser)
        , map NewInjury (s "injuries" </> s "new")
        , map EditInjury (s "injuries" </> idParser </> s "edit")
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
            "/injuries/" ++ Id.toString id

        NewInjury ->
            "injuries/new"

        EditInjury id ->
            Id.toString id ++ "/edit"
        Account -> 
            "/account"
