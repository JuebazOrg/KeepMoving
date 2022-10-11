module Injuries.Injuries exposing (..)

import Browser.Navigation as Nav
import Bulma.Styled.Components as BC
import Clients.InjuryClient as Client
import Compare as Compare
import Components.Elements as C
import Css exposing (..)
import Date exposing (..)
import Dict as Dict
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Injuries.Filter as Filters
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Colors exposing (grey)
import Theme.Icons as I
import Theme.Spacing as SP
import Util.Date exposing (formatMMDD)


type alias Model =
    { injuries : WebData (List Injury), filters : Filters.Model, navKey : Nav.Key }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { injuries = RemoteData.NotAsked
      , filters = Filters.init
      , navKey = navKey
      }
    , getInjuries
    )


type Msg
    = FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | OpenDetail Injury
    | FiltersMsg Filters.Msg


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )

        FiltersMsg subMsg ->
            ( { model | filters = Filters.update subMsg model.filters }, Cmd.none )

        OpenDetail injury ->
            ( model, Route.pushUrl (Route.Injury injury.id) model.navKey )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ]
            , C.addButton [ A.href (Route.routeToString Route.NewInjury) ] [ text "injury" ]
            ]
        , map FiltersMsg <| Filters.view model.filters
        , viewInjuriesOrError model
        ]


viewInjuriesOrError : Model -> Html Msg
viewInjuriesOrError model =
    case model.injuries of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injuries ->
            if List.length injuries == 0 then
                h3 [] [ text "No Injuries yet... keep going like that :) " ]

            else
                viewInjuries injuries model.filters

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewInjuries : List Injury -> Filters.Model -> Html Msg
viewInjuries injuries filters =
    div [ A.css [ displayFlex, flexDirection column ] ]
        [ injuries
            |> filterWith filters.filters
            |> orderBy filters.order.value
            |> viewInjuriesByYear
        ]


filterWith : Filters.Filters -> List Injury -> List Injury
filterWith filters injuries =
    if filters.region.value == Nothing then
        injuries

    else
        injuries
            |> List.filter (\i -> Just i.bodyRegion.region == filters.region.value)


orderBy : Maybe Filters.Order -> List Injury -> List Injury
orderBy order injuries =
    order
        |> Maybe.map
            (\o ->
                case o of
                    Filters.LeastRecent ->
                        injuries
                            |> List.sortWith (Compare.compose .startDate Date.compare)

                    Filters.MostRecent ->
                        injuries
                            |> List.sortWith (Compare.compose .startDate Date.compare)
                            |> List.reverse
            )
        |> Maybe.withDefault injuries


viewInjuriesByYear : List Injury -> Html Msg
viewInjuriesByYear injuries =
    injuriesByYear injuries
        |> Dict.toList
        |> List.map
            (\( year, yearInjuries ) ->
                div [ A.css [ margin SP.medium ] ]
                    [ viewYear year
                    , div [] <| List.map viewInjury yearInjuries
                    ]
            )
        |> List.reverse
        |> div []


viewYear : Int -> Html msg
viewYear year =
    div [] [ hr [] [], label [ A.css [ color grey ] ] [ text <| String.fromInt year ], hr [] [] ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    let
        activeTag =
            if isActive injury then
                C.warningTag [ A.css [ marginLeft SP.small ] ] [ text "active" ]

            else
                C.empty
    in
    BC.card
        [ A.class "elem", onClick <| OpenDetail injury, A.css [ borderRadius SP.small, marginTop SP.medium, important (maxWidth (px 500)) ] ]
        [ BC.cardHeader []
            [ BC.cardTitle []
                [ C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                , activeTag
                ]
            , BC.cardIcon []
                [ C.icon [] [ i [ A.class I.calendar ] [] ]
                , span [] [ text <| formatMMDD injury.startDate ]
                ]
            ]
        , BC.cardContent [] [ text <| injury.location ]
        ]
