module Injuries.Filters exposing (..)

import Components.Dropdown2 as DD
import Css exposing (em, margin)
import Domain.Regions exposing (Region, fromRegion, regions)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A


type alias Model =
    { order : DD.Model Order, filters : Filters }


type alias Filters =
    { region : DD.Model Region }


type Order
    = LeastRecent
    | MostRecent


type Msg
    = OrderDropdownMsg (DD.Msg (Maybe Order))
    | RegionFilterDropDownMsg (DD.Msg (Maybe Region))


init : Model
init =
    { order = DD.init
    , filters = { region = DD.init }
    }


setRegion : Filters -> DD.Model Region -> Filters
setRegion filter region =
    { filter | region = region }


update : Msg -> Model -> Model
update msg model =
    case msg of
        OrderDropdownMsg subMsg ->
            { model | order = DD.update model.order subMsg }

        RegionFilterDropDownMsg subMsg ->
            { model | filters = setRegion model.filters (DD.update model.filters.region subMsg) }


view : Model -> Html Msg
view model =
    div []
        [ span [ A.css [ margin (Css.em 0.2) ] ] [ orderDropDown model ]
        , regionFilterDropdown model
        ]


orderOptions : List (DD.Option Order)
orderOptions =
    [ { value = Just LeastRecent, label = "least recent" }, { value = Just MostRecent, label = "most recent" } ]


regionOptions : List (DD.Option Region)
regionOptions =
    regions
        |> List.map (\r -> { value = Just r, label = fromRegion r })


regionFilterDropdown : Model -> Html Msg
regionFilterDropdown model =
    map RegionFilterDropDownMsg <| DD.view model.filters.region regionOptions "Region"


orderDropDown : Model -> Html Msg
orderDropDown model =
    map OrderDropdownMsg <| DD.view model.order orderOptions "Order by"
