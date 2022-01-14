module Pages.EditInjury.Form exposing (..)

import Cmd.Extra as Cmd
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Date as Date
import Domain.Injury exposing (Injury, InjuryType, injuryTypes, injuryTypeToString)
import Domain.Regions exposing (Region, Side, regions, sides, fromRegion, fromSide)
import Time exposing (Month(..))


type alias Model =
    { regionDropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , injuryTypeDropDown : DD.Model InjuryType
    , startDate : DP.Model
    , endDate : DP.Model
    , description : String
    , location : String
    , how : String
    }


init : Injury -> Model
init injury =
    { regionDropdown = initRegionDD injury
    , sideDropDown = initSideDD injury
    , injuryTypeDropDown = initInjuryTypeDD injury
    , startDate = DP.init (Just injury.startDate)
    , endDate = DP.init injury.endDate
    , description = injury.description
    , location = injury.location
    , how = injury.how
    }


update : Msg -> Model -> Model
update msg model =
    model



type Msg
    = DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | StartDateChange DP.Msg
    | EndDateChange DP.Msg
    | UpdateDescription String
    | UpdateLocation String
    | InjuryTypeDropDownMsg (DD.Msg InjuryType)


initRegionDD : Injury -> DD.Model Region
initRegionDD injury =
    DD.init regionDropdownOptions (selectedToOption injury.bodyRegion.region regionDropdownOptions) "Region" DD.defaultProps


initSideDD : Injury -> DD.Model Side
initSideDD injury =
    let
        selectedSide =
            case injury.bodyRegion.side of
                Nothing ->
                    Nothing

                Just a ->
                    selectedToOption a sideDropDownOptions
    in
    DD.init sideDropDownOptions selectedSide "Side" DD.defaultProps


initInjuryTypeDD : Injury -> DD.Model InjuryType
initInjuryTypeDD injury =
    DD.init injuryTypeDropDownOptions (selectedToOption injury.injuryType injuryTypeDropDownOptions) "Type" DD.defaultProps




regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = region })


sideDropDownOptions : List (DD.Option Side)
sideDropDownOptions =
    sides |> List.map (\side -> { label = fromSide side, value = side })


injuryTypeDropDownOptions : List (DD.Option InjuryType)
injuryTypeDropDownOptions =
    injuryTypes |> List.map (\injuryType -> { label = injuryTypeToString injuryType, value = injuryType })


selectedToOption : a -> List (DD.Option a) -> Maybe (DD.Option a)
selectedToOption element values =
    values
        |> List.filter (\i -> i.value == element)
        |> List.head
