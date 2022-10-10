module Pages.InjuryForm exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Form as BF
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Css exposing (..)
import Domain.Injury exposing (Injury, InjuryType, injuryTypeToString, injuryTypes)
import Domain.Regions exposing (Region, Side, fromRegion, regions, sideToString, sides)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onInput)
import Theme.Mobile as M
import Theme.Spacing as SP
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


initEmpty : Model
initEmpty =
    { regionDropdown = DD.init regionDropdownOptions Nothing "Region" DD.defaultProps
    , sideDropDown = DD.init sideDropDownOptions Nothing "Side" DD.defaultProps
    , injuryTypeDropDown = DD.init injuryTypeDropDownOptions Nothing "Type" DD.defaultProps
    , startDate = DP.init Nothing
    , endDate = DP.init Nothing
    , description = ""
    , location = ""
    , how = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropDownMsg subMsg ->
            { model | regionDropdown = DD.update model.regionDropdown subMsg }

        SideDropDownMsg subMsg ->
            { model | sideDropDown = DD.update model.sideDropDown subMsg }

        InjuryTypeDropDownMsg subMsg ->
            { model | injuryTypeDropDown = DD.update model.injuryTypeDropDown subMsg }

        StartDateChange subMsg ->
            { model | startDate = DP.update subMsg model.startDate }

        EndDateChange subMsg ->
            { model | endDate = DP.update subMsg model.endDate }

        UpdateDescription content ->
            { model | description = content }

        UpdateLocation content ->
            { model | location = content }

        UpdateHow content ->
            { model | how = content }


type Msg
    = DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | StartDateChange DP.Msg
    | EndDateChange DP.Msg
    | UpdateDescription String
    | UpdateLocation String
    | InjuryTypeDropDownMsg (DD.Msg InjuryType)
    | UpdateHow String


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
    sides
        |> List.map (\side -> { label = sideToString side, value = side })


injuryTypeDropDownOptions : List (DD.Option InjuryType)
injuryTypeDropDownOptions =
    injuryTypes |> List.map (\injuryType -> { label = injuryTypeToString injuryType, value = injuryType })


selectedToOption : a -> List (DD.Option a) -> Maybe (DD.Option a)
selectedToOption element values =
    values
        |> List.filter (\i -> i.value == element)
        |> List.head


view : Model -> Html Msg
view model =
    BC.cardContent [ A.css [ flex (int 1), M.onMobile [ important <| padding (px 0) ] ] ]
        [ div [ A.css [ displayFlex, alignItems center, M.onMobile [ flexDirection column, alignItems flexStart ] ] ]
            [ span [ A.css [ margin SP.small ] ] [ map DropDownMsg (DD.viewDropDown model.regionDropdown) ]
            , span [ A.css [ margin SP.small ] ] [ map SideDropDownMsg (DD.viewDropDown model.sideDropDown) ]
            , span [ A.css [ margin SP.small ] ] [ map InjuryTypeDropDownMsg (DD.viewDropDown model.injuryTypeDropDown) ]
            ]
        , viewLocationInput model.location
        , viewDescriptionInput model.description
        , viewHowInput model.how
        , span [ A.css [ displayFlex, M.onMobile [ flexDirection column ] ] ]
            [ viewStartDate model
            , viewEndDate model
            ]
        ]


viewStartDate : Model -> Html Msg
viewStartDate model =
    BF.field [] [ BF.controlLabel [] [ text "Start date" ], map StartDateChange (DP.view model.startDate) ]


viewEndDate : Model -> Html Msg
viewEndDate model =
    BF.field [ A.css [ marginLeft (px 10) ] ] [ BF.controlLabel [] [ text "End date" ], map EndDateChange (DP.view model.endDate) ]


viewDescriptionInput : String -> Html Msg
viewDescriptionInput content =
    BF.field []
        [ BF.controlLabel [] [ text "description" ]
        , BF.controlTextArea
            BF.controlTextAreaModifiers
            [ onInput UpdateDescription ]
            []
            [ text content ]
        ]


viewHowInput : String -> Html Msg
viewHowInput content =
    BF.field []
        [ BF.controlLabel [] [ text "how it happen" ]
        , BF.controlTextArea
            BF.controlTextAreaModifiers
            []
            [ onInput UpdateHow ]
            [ text content ]
        ]


viewLocationInput : String -> Html Msg
viewLocationInput content =
    BF.field [ A.css [ flex (int 3), marginRight (px 10) ] ]
        [ BF.controlLabel [] [ text "location details" ]
        , BF.controlInput BF.controlInputModifiers [ onInput UpdateLocation ] [ A.value content ] []
        ]
