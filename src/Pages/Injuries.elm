module Pages.Injuries exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Compare exposing (Comparator)
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (controlCheckBox)
import Css exposing (..)
import Date exposing (..)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onCheck, onClick)
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Icons as I
import Theme.Spacing as SP



-- todo : Modal se gere tout seul


type alias Model =
    { injuries : WebData (List Injury), filters : Filters, navKey : Nav.Key, orders : DD.Model Order }


type alias Filters =
    { region : DD.Model Region, side : DD.Model Side, active : Bool }


type Order
    = LeastRecent
    | MostRecent


orders : List Order
orders =
    [ LeastRecent, MostRecent ]


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { injuries = RemoteData.NotAsked
      , filters =
            { region = DD.init regionDropdownOptions "Regions" DD.defaultProps
            , side = DD.init sideDropdownOptions "Side" DD.defaultProps
            , active = False
            }
      , navKey = navKey
      , orders = DD.init ordersDropdownOptions "Order by" DD.defaultProps
      }
    , getInjuries
    )


type Msg
    = FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | RegionFilterMsg (DD.Msg Region)
    | SideFilterMsg (DD.Msg Side)
    | OrderMsg (DD.Msg Order)
    | OpenDetail Injury
    | ActiveFilterChecked Bool


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    let
        filters =
            model.filters
    in
    case msg of
        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )

        RegionFilterMsg subMsg ->
            ( { model | filters = { filters | region = DD.update model.filters.region subMsg } }, Cmd.none )

        SideFilterMsg subMsg ->
            ( { model | filters = { filters | side = DD.update model.filters.side subMsg } }, Cmd.none )

        OpenDetail injury ->
            ( model, Route.pushUrl (Route.Injury injury.id) model.navKey )

        OrderMsg subMsg ->
            ( { model | orders = DD.update model.orders subMsg }, Cmd.none )

        ActiveFilterChecked bool ->
            ( { model | filters = { filters | active = bool } }, Cmd.none )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


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
    if filters.active then
        filterBySide |> List.filter (\i -> Domain.Injury.isActive i)

    else
        filterBySide


orderInjuries : Maybe Order -> List Injury -> List Injury
orderInjuries order injuries =
    order
        |> Maybe.map
            (\o ->
                case o of
                    LeastRecent ->
                        injuries
                            |> List.sortWith (Compare.compose .startDate Date.compare)

                    MostRecent ->
                        injuries
                            |> List.sortWith (Compare.compose .startDate Date.compare)
                            |> List.reverse
            )
        |> Maybe.withDefault injuries


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ]
            , C.addButton [ A.href (Route.routeToString Route.NewInjury) ] [ text "injury" ]
            ]
        , viewFilters model
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
            viewInjuries injuries model.filters model.orders

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewInjuries : List Injury -> Filters -> DD.Model Order -> Html Msg
viewInjuries injuries filters order =
    div [ A.css [ displayFlex, flexDirection column ] ]
        (injuries
            |> filterInjuries filters
            |> orderInjuries (DD.getSelectedValue order)
            |> List.map
                (\i -> viewInjury i)
        )


viewInjury : Injury -> Html Msg
viewInjury injury =
    let
        startDate =
            injury.startDate
                |> Date.toIsoString
    in
    card
        [ onClick <| OpenDetail injury, A.css [ borderRadius SP.small, marginTop SP.medium, important (maxWidth (px 500)) ] ]
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
                , span [] [ text startDate ]
                , C.icon
                    [ A.css [ paddingLeft SP.small ] ]
                    [ i [ A.class I.edit ] []
                    ]
                ]
            ]
        , cardContent [] [ text <| injury.location ]
        ]


viewFilters : Model -> Html Msg
viewFilters model =
    div [ A.css [ displayFlex, alignItems center, flexWrap wrap ] ]
        [ span [ A.css [ marginRight SP.medium ] ] [ regionFilter model.filters ]
        , span [ A.css [ marginRight SP.medium ] ] [ sideFilter model.filters ]
        , span [ A.css [ marginRight SP.medium ] ] [ viewOrderDropDown model ]
        , span [] [ controlCheckBox False [] [] [ onCheck ActiveFilterChecked ] [ text "actif injuries" ] ]
        ]


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = region })


regionFilter : Filters -> Html Msg
regionFilter filters =
    map RegionFilterMsg (DD.viewDropDown filters.region)


viewOrderDropDown : Model -> Html Msg
viewOrderDropDown model =
    map OrderMsg (DD.viewDropDown model.orders)


sideDropdownOptions : List (DD.Option Side)
sideDropdownOptions =
    sides
        |> List.map (\side -> { label = fromSide side, value = side })


ordersDropdownOptions : List (DD.Option Order)
ordersDropdownOptions =
    orders
        |> List.map
            (\order ->
                { label =
                    case order of
                        LeastRecent ->
                            "Least Recent"

                        MostRecent ->
                            "Most recent"
                , value = order
                }
            )


sideFilter : Filters -> Html Msg
sideFilter filters =
    map SideFilterMsg (DD.viewDropDown filters.side)
