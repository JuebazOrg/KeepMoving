module Pages.Injuries.Injuries exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (..)
import Components.Elements as C
import Css exposing (..)
import Date exposing (..)
import Dict as Dict
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Event exposing (Event)
import EventCalendar as Calendar
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Navigation.Route as Route
import Pages.Injuries.Filters as Filters
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Colors as Colors exposing (grey)
import Theme.Icons as I
import Theme.Spacing as SP
import Util.Date exposing (formatMMDD)


type alias Model =
    { injuries : WebData (List Injury), filters : Filters.Model, calendar : Maybe Calendar.Model, navKey : Nav.Key }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { injuries = RemoteData.NotAsked
      , filters = Filters.init
      , calendar = Nothing
      , navKey = navKey
      }
    , getInjuries
    )


type Msg
    = FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | OpenDetail Injury
    | FiltersMsg Filters.Msg
    | CalendarView
    | ViewList
    | CalendarMsg Calendar.Msg


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

        ViewList ->
            ( { model | calendar = Nothing }, Cmd.none )

        CalendarView ->
            let
                ( calendarModel, cmd ) =
                    Calendar.init
            in
            ( { model | calendar = Just calendarModel }, Cmd.map CalendarMsg cmd )

        CalendarMsg subMsg ->
            let
                ( calendarModel, cmd ) =
                    case model.calendar of
                        Nothing ->
                            ( Nothing, Cmd.none )

                        -- trouver une meilleur facon de faire ca
                        Just c ->
                            let
                                ( a, b ) =
                                    Calendar.update subMsg c
                            in
                            ( Just a, b )
            in
            ( { model | calendar = calendarModel }, Cmd.map CalendarMsg cmd )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


buildEventModel : List Injury -> List Event
buildEventModel injuries =
    injuries
        |> List.map
            (\i ->
                { name =
                    (i.bodyRegion.side
                        |> Maybe.map fromSide
                        |> Maybe.withDefault ""
                    )
                        ++ " " ++ fromRegion i.bodyRegion.region
                , startDate = i.startDate
                , endDate = i.endDate
                , description = i.description
                , color = Colors.cyan
                }
            )


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ]
                [ text "Injuries" ]
            , div []
                [ C.primaryIconButton "fa fa-list" [ onClick ViewList ] [ text <| "List" ]
                , C.primaryIconButton "fa fa-calendar" [ A.css [ marginLeft SP.small ], onClick CalendarView ] [ text <| "calendar" ]
                , C.addButton [ A.css [ marginLeft SP.small ], A.href (Route.routeToString Route.NewInjury) ] [ text "injury" ]
                ]
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
            case model.calendar of
                Just calendar ->
                    viewCalendarInjuries calendar (buildEventModel injuries)

                Nothing ->
                    viewInjuries injuries model.filters

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewCalendarInjuries : Calendar.Model -> List Event -> Html Msg
viewCalendarInjuries calendarModel events =
    map CalendarMsg <| Calendar.view events calendarModel


viewInjuries : List Injury -> Filters.Model -> Html Msg
viewInjuries injuries filterModel =
    div [ A.css [ displayFlex, flexDirection column ] ]
        [ injuries
            |> Filters.filterInjuries filterModel.filters
            |> Filters.orderInjuries filterModel.order
            |> viewInjuriesByYear
        ]


viewInjuriesByYear : List Injury -> Html Msg
viewInjuriesByYear injuries =
    div []
        (injuriesByYear injuries
            |> Dict.toList
            |> List.map
                (\( k, v ) ->
                    div [ A.css [ margin SP.medium ] ]
                        [ viewYear k
                        , div [] <| List.map (\i -> viewInjury i) v
                        ]
                )
            |> List.reverse
        )


viewYear : Int -> Html msg
viewYear year =
    div [] [ hr [] [], label [ A.css [ color grey ] ] [ text <| String.fromInt year ], hr [] [] ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    card
        [ A.class "elem", onClick <| OpenDetail injury, A.css [ borderRadius SP.small, marginTop SP.medium, important (maxWidth (px 500)) ] ]
        [ cardHeader []
            [ cardTitle []
                [ C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                , if isActive injury then
                    C.warningTag [ A.css [ marginLeft SP.small ] ] [ text "active" ]

                  else
                    C.empty
                ]
            , cardIcon []
                [ C.icon
                    []
                    [ i [ A.class I.calendar ] []
                    ]
                , span [] [ text <| formatMMDD injury.startDate ]
                ]
            ]
        , cardContent [] [ text <| injury.location ]
        ]
