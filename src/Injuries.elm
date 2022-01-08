module Injuries exposing (..)

import Assemblers.InjuryDecoder as InjuryDecoder
import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Modal as CM
import Css exposing (..)
import Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Http
import InjuryModal exposing (viewModal)
import Json.Decode as Decode
import Material.Icons exposing (build)
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Icons as I



-- todo : Modal se gere tout seul


type alias Model =
    { injuries : WebData (List Injury), filters : Filters, selectedInjury : Maybe Injury }


type alias Filters =
    { region : DD.Model Region, side : DD.Model Side }


init : ( Model, Cmd Msg )
init =
    ( { injuries = RemoteData.NotAsked
      , filters =
            { region = DD.init regionDropdownOptions "Regions"
            , side = DD.init sideDropdownOptions "Side"
            }
      , selectedInjury = Nothing
      }
    , getInjuries
    )


type Msg
    = FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | RegionFilterMsg (DD.Msg Region)
    | SideFilterMsg (DD.Msg Side)
    | OpenDetail Injury


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )

        RegionFilterMsg subMsg ->
            ( { model | filters = { side = model.filters.side, region = DD.update model.filters.region subMsg } }, Cmd.none )

        SideFilterMsg subMsg ->
            ( { model | filters = { side = DD.update model.filters.side subMsg, region = model.filters.region } }, Cmd.none )

        OpenDetail injury ->
            ( { model | selectedInjury = Just injury }, Cmd.none )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


viewInjuriesOrError : Model -> Html Msg
viewInjuriesOrError model =
    case model.injuries of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injuries ->
            viewInjuries model.filters injuries

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ]
            , C.addButton [ A.href "/injuries/new" ] [ text "injury" ]
            ]
        , viewFilters model.filters
        , viewInjuriesOrError model

        -- , Maybe.map (\selected -> viewDetails selected) model.selectedInjury |> Maybe.withDefault C.empty
        ]


viewInjuries : Filters -> List Injury -> Html Msg
viewInjuries filters injuries =
    div [ A.css [ displayFlex, flexDirection column ] ]
        (injuries
            |> filterInjuries filters
            |> List.map
                (\i -> viewInjury i)
        )


filterInjuries : Filters -> List Injury -> List Injury
filterInjuries filters injuries =
    let
        region =
            DD.getSelectedValue filters.region

        side =
            DD.getSelectedValue filters.side
    in
    let
        filterByRegion =
            Maybe.map
                (\r -> injuries |> List.filter (\i -> i.bodyRegion.region == r))
                region
                |> Maybe.withDefault injuries
    in
    let
        filterBySide =
            if side == Nothing then
                filterByRegion

            else
                List.filter (\i -> i.bodyRegion.side == side) filterByRegion
    in
    filterBySide


viewInjury : Injury -> Html Msg
viewInjury injury =
    card
        [ A.css [ borderRadius (px 5), marginTop (px 10), important (maxWidth (px 500)) ] ]
        [ cardHeader []
            [ cardTitle []
                [ span [ A.css [ paddingRight (px 7) ] ] [ text <| injury.location ]
                , C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                ]
            , cardIcon []
                [ C.icon
                    []
                    [ i [ A.class I.calendar ] []
                    ]
                , span [] [ text <| Date.toIsoString injury.startDate ]
                , C.icon
                    [ A.css [ paddingLeft (px 5) ] ]
                    [ i [ A.class I.edit ] []
                    ]
                ]
            ]
        , cardContent [] [ text injury.description ]
        , a [ A.href <| Client.injuryPath injury.id ] [ text "details" ]
        ]


viewFilters : Filters -> Html Msg
viewFilters filters =
    div [ A.css [ displayFlex ] ] [ span [ A.css [ marginRight (px 10) ] ] [ regionFilter filters ], sideFilter filters ]


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = region })


regionFilter : Filters -> Html Msg
regionFilter filters =
    map RegionFilterMsg (DD.viewDropDown filters.region)


sideDropdownOptions : List (DD.Option Side)
sideDropdownOptions =
    sides
        |> List.map (\side -> { label = fromSide side, value = side })


sideFilter : Filters -> Html Msg
sideFilter filters =
    map SideFilterMsg (DD.viewDropDown filters.side)
