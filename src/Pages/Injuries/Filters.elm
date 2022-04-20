module Pages.Injuries.Filters exposing (..)

import Compare exposing (Comparator)
import Components.Dropdown as DD exposing (defaultProps)
import Components.Elements as C
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
import Theme.Mobile as M
import Theme.Spacing as SP


type alias Filters =
    { region : DD.Model Region, side : DD.Model Side, active : Bool }


type alias Model =
    { filters : Filters, isOpen : Bool, order : DD.Model Order }


type Order
    = LeastRecent
    | MostRecent


type Msg
    = Trigger
    | OrderMsg (DD.Msg Order)
    | ClearAll
    | Filter FilterMsg


type FilterMsg
    = RegionFilterMsg (DD.Msg Region)
    | SideFilterMsg (DD.Msg Side)
    | ActiveFilterChecked Bool


orders : List Order
orders =
    [ LeastRecent, MostRecent ]


init : Model
init =
    { filters =
        { region = DD.init regionDropdownOptions Nothing "Regions" { defaultProps | maxSize = Just 200 }
        , side = DD.init sideDropdownOptions Nothing "Side" DD.defaultProps
        , active = False
        }
    , isOpen = False
    , order = DD.init ordersDropdownOptions Nothing "Order By" DD.defaultProps
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        OrderMsg subMsg ->
            { model | order = DD.update model.order subMsg }

        Trigger ->
            { model | isOpen = not model.isOpen }

        ClearAll ->
            init

        Filter sub ->
            { model | filters = updateFilter sub model.filters }


updateFilter : FilterMsg -> Filters -> Filters
updateFilter msg filters =
    case msg of
        RegionFilterMsg subMsg ->
            { filters | region = DD.update filters.region subMsg }

        SideFilterMsg subMsg ->
            { filters | side = DD.update filters.side subMsg }

        -- todo
        ActiveFilterChecked bool ->
            { filters | active = bool }


view : Model -> Html Msg
view model =
    div [ A.css [ displayFlex, flexDirection rowReverse ] ]
        [ C.roundIconButton I.filter [ onClick Trigger ] []
        , CS.view model.isOpen 50 [ viewContent model ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    div [ A.css [ displayFlex, M.onMobile [ flexDirection column ] ] ]
        [ div [ A.css [ displayFlex, flexDirection rowReverse, margin SP.small ] ] [ C.closeButton [ onClick Trigger ] [] ]
        , div [ A.css [ displayFlex ] ]
            [ span [ A.css [ marginRight SP.small ] ] [ regionFilterView model.filters ]
            , span [ A.css [ marginRight SP.small ] ] [ sideFilterView model.filters ]
            , span [ A.css [ marginRight SP.small ] ] [ viewOrderDropDown model ]
            ]
        , hr [] []
        , span [] [ controlCheckBox False [] [] [ onCheck ActiveFilterChecked ] [ text "actif injuries" ] ] |> map Filter
        , hr [] []
        , a [ onClick ClearAll ] [ text "clear all" ]
        ]



-- todo : filter not working. Missing items when no filters. Implement tests 


filterInjuries : Filters -> List Injury -> List Injury
filterInjuries filters injuries =
    injuries



-- let
--     region =
--         DD.getSelectedValue filters.region
--     maybeSide =
--         DD.getSelectedValue filters.side
-- in
-- let
--     filterByRegion injs =
--         if region == Nothing then
--             injs
--         else
--             region
--                 |> Maybe.map
--                     (\r -> injs |> List.filter (\i -> i.bodyRegion.region == r))
--                 |> Maybe.withDefault injs
-- in
-- let
--     filterBySide injs =
--         if maybeSide == Nothing then
--             injs
--         else
--             injs
--                 |> List.filter (\i -> i.bodyRegion.side == maybeSide)
-- in
-- injuries
--     |> filterBySide
--     |> filterByRegion
--     |> List.filter (\i -> Domain.Injury.isActive i)


orderInjuries : DD.Model Order -> List Injury -> List Injury
orderInjuries order injuries =
    DD.getSelectedValue order
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


regionFilterView : Filters -> Html Msg
regionFilterView filters =
    map RegionFilterMsg (DD.viewDropDown filters.region) |> map Filter


viewOrderDropDown : Model -> Html Msg
viewOrderDropDown model =
    map OrderMsg (DD.viewDropDown model.order)


sideDropdownOptions : List (DD.Option Side)
sideDropdownOptions =
    sides
        |> List.map (\side -> { label = sideToString side, value = side })


ordersDropdownOptions : List (DD.Option Order)
ordersDropdownOptions =
    orders
        |> List.map
            (\order ->
                { label =
                    case order of
                        LeastRecent ->
                            "Least recent"

                        MostRecent ->
                            "More recent"
                , value = order
                }
            )


sideFilterView : Filters -> Html Msg
sideFilterView filters =
    map SideFilterMsg (DD.viewDropDown filters.side) |> map Filter
