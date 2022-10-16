module CreateInjury.Form exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Form as BF
import Components.Calendar.DatePicker as DP
import Components.Dropdown2 as DD
import Css exposing (..)
import Domain.Injury exposing (InjuryType, injuryTypeToString, injuryTypes)
import Domain.Regions exposing (Region, Side, fromRegion, regions, sideToString, sides)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onInput)
import Theme.Mobile as M
import Theme.Spacing as SP
import Time exposing (Month(..))


type alias Model =
    { region : DD.Model Region
    , side : DD.Model Side
    , injuryType : DD.Model InjuryType
    , startDate : DP.Model
    , endDate : DP.Model
    , description : String
    , location : String
    , how : String
    }


init : Model
init =
    { region = DD.init
    , side = DD.init
    , injuryType = DD.init
    , startDate = DP.init Nothing
    , endDate = DP.init Nothing
    , description = ""
    , location = ""
    , how = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        RegionMsg subMsg ->
            { model | region = DD.update model.region subMsg }

        SideMsg subMsg ->
            { model | side = DD.update model.side subMsg }

        InjuryTypeDropDownMsg subMsg ->
            { model | injuryType = DD.update model.injuryType subMsg }

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
    = RegionMsg (DD.Msg (Maybe Region))
    | SideMsg (DD.Msg (Maybe Side))
    | StartDateChange DP.Msg
    | EndDateChange DP.Msg
    | UpdateDescription String
    | UpdateLocation String
    | InjuryTypeDropDownMsg (DD.Msg (Maybe InjuryType))
    | UpdateHow String


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = Just region })


sideDropDownOptions : List (DD.Option Side)
sideDropDownOptions =
    sides
        |> List.map (\side -> { label = sideToString side, value = Just side })


injuryTypeDropDownOptions : List (DD.Option InjuryType)
injuryTypeDropDownOptions =
    injuryTypes |> List.map (\injuryType -> { label = injuryTypeToString injuryType, value = Just injuryType })


view : Model -> Html Msg
view model =
    BC.cardContent [ A.css [ flex (int 1), M.onMobile [ important <| padding (px 0) ] ] ]
        [ div [ A.css [ displayFlex, alignItems center, M.onMobile [ flexDirection column, alignItems flexStart ] ] ]
            [ viewRegionDropdown model, viewSideDropdown model, viewInjuryTypeDropdown model ]
        , viewLocationInput model.location
        , viewDescriptionInput model.description
        , viewHowInput model.how
        , span [ A.css [ displayFlex, M.onMobile [ flexDirection column ] ] ]
            [ viewStartDate model
            , viewEndDate model
            ]
        ]


regionOptions : List (DD.Option Region)
regionOptions =
    regions
        |> List.map (\r -> { value = Just r, label = fromRegion r })


sideOptions : List (DD.Option Side)
sideOptions =
    sides
        |> List.map (\r -> { value = Just r, label = sideToString r })


injuryTypesOptions : List (DD.Option InjuryType)
injuryTypesOptions =
    injuryTypes
        |> List.map (\r -> { value = Just r, label = injuryTypeToString r })


viewRegionDropdown : Model -> Html Msg
viewRegionDropdown model =
    span [ A.css [ margin SP.small ] ] [ map RegionMsg (DD.view model.region regionOptions "Region") ]


viewInjuryTypeDropdown : Model -> Html Msg
viewInjuryTypeDropdown model =
    span [ A.css [ margin SP.small ] ] [ map InjuryTypeDropDownMsg (DD.view model.injuryType injuryTypesOptions "Injury type") ]


viewSideDropdown : Model -> Html Msg
viewSideDropdown model =
    span [ A.css [ margin SP.small ] ] [ map SideMsg (DD.view model.side sideOptions "Side") ]


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
