module Pages.Injuries.Filters exposing (..)

import Compare exposing (Comparator)
import Components.Dropdown as DD
import Components.Form exposing (controlCheckBox)
import Components.SlidingPanel as CS
import Css exposing (..)
import Date exposing (..)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onCheck, onClick)
import Theme.Icons as I
import Theme.Spacing as SP


type alias Filters =
    { region : DD.Model Region, side : DD.Model Side, active : Bool }


type alias Model =
    { filters : Filters, isOpen : Bool }


type Order
    = LeastRecent
    | MostRecent


type Msg
    = Trigger
    | RegionFilterMsg (DD.Msg Region)
    | SideFilterMsg (DD.Msg Side)
    | OrderMsg (DD.Msg Order)
    | ActiveFilterChecked Bool


orders : List Order
orders =
    [ LeastRecent, MostRecent ]


init : Model
init =
    { filters =
        { region = DD.init regionDropdownOptions "Regions" DD.defaultProps
        , side = DD.init sideDropdownOptions "Side" DD.defaultProps
        , active = False
        }
    , isOpen = False
    }


update : Msg -> Model -> Model
update msg model =
    let
        filters =
            model.filters
    in
    case msg of
        RegionFilterMsg subMsg ->
            { model | filters = { filters | region = DD.update model.filters.region subMsg } }

        SideFilterMsg subMsg ->
            { model | filters = { filters | side = DD.update model.filters.side subMsg } }

        OrderMsg subMsg ->
            model

        -- todo
        ActiveFilterChecked bool ->
            { model | filters = { filters | active = bool } }

        Trigger ->
            { model | isOpen = not model.isOpen }


view : Model -> Html Msg
view model =
    CS.view model.isOpen Trigger [ viewContent model ] "Filters"


viewContent : Model -> Html Msg
viewContent model =
    div [ A.css [ displayFlex, alignItems center, flexWrap wrap ] ]
        [ span [ A.css [ marginRight SP.medium ] ] [ regionFilter model.filters ]
        , span [ A.css [ marginRight SP.medium ] ] [ sideFilter model.filters ]

        -- , span [ A.css [ marginRight SP.medium ] ] [ viewOrderDropDown model ]
        , span [] [ controlCheckBox False [] [] [ onCheck ActiveFilterChecked ] [ text "actif injuries" ] ]
        ]


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


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = region })


regionFilter : Filters -> Html Msg
regionFilter filters =
    map RegionFilterMsg (DD.viewDropDown filters.region)



-- viewOrderDropDown : Model -> Html Msg
-- viewOrderDropDown model =
--     map OrderMsg (DD.viewDropDown model.orders)


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
                            "older"

                        MostRecent ->
                            "recent"
                , value = order
                }
            )


sideFilter : Filters -> Html Msg
sideFilter filters =
    map SideFilterMsg (DD.viewDropDown filters.side)
