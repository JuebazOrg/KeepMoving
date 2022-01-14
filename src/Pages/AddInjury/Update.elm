module Pages.AddInjury.Update exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Components.Elements as C
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Http
import Navigation.Route as Route
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
    , navKey : Nav.Key
    }



-- todo: validation  + error + loading


init : Nav.Key -> Model
init navKey =
    { regionDropdown = DD.init regionDropdownOptions Nothing "Region" DD.defaultProps
    , sideDropDown = DD.init sideDropDownOptions Nothing "Side" DD.defaultProps
    , injuryTypeDropDown = DD.init injuryTypeDropDownOptions Nothing "Type" DD.defaultProps
    , startDate = DP.init Nothing
    , endDate = DP.init Nothing
    , description = ""
    , location = ""
    , how = ""
    , navKey = navKey
    }


type Msg
    = CloseModal
    | Save
    | DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | StartDateChange DP.Msg
    | EndDateChange DP.Msg
    | InjuryCreated (Result Http.Error ())
    | UpdateDescription String
    | UpdateLocation String
    | UpdateHow String
    | InjuryTypeDropDownMsg (DD.Msg InjuryType)


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        DropDownMsg subMsg ->
            ( { model | regionDropdown = DD.update model.regionDropdown subMsg }, Cmd.none )

        SideDropDownMsg subMsg ->
            ( { model | sideDropDown = DD.update model.sideDropDown subMsg }, Cmd.none )

        InjuryTypeDropDownMsg subMsg ->
            ( { model | injuryTypeDropDown = DD.update model.injuryTypeDropDown subMsg }, Cmd.none )

        StartDateChange subMsg ->
            ( { model | startDate = DP.update subMsg model.startDate }, Cmd.none )

        EndDateChange subMsg ->
            ( { model | startDate = DP.update subMsg model.endDate }, Cmd.none )

        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        Save ->
            ( model, createNewInjury <| createNewInjuryFromForm model )

        UpdateDescription content ->
            ( { model | description = content }, Cmd.none )

        UpdateLocation content ->
            ( { model | location = content }, Cmd.none )

        UpdateHow content ->
            ( { model | how = content }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Route.pushUrl Route.Injuries model.navKey )

                Err error ->
                    ( model, Cmd.none )



-- todo : date from today


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated


createNewInjuryFromForm : Model -> NewInjury
createNewInjuryFromForm model =
    { bodyRegion =
        { region = Maybe.withDefault Other (DD.getSelectedValue model.regionDropdown)
        , side = DD.getSelectedValue model.sideDropDown
        }
    , location = model.location
    , description = model.description
    , startDate = Maybe.withDefault defaultDate model.startDate
    , endDate = model.endDate
    , how = model.how
    , injuryType = Maybe.withDefault OtherInjuryType (DD.getSelectedValue model.injuryTypeDropDown)
    , checkPoints = []
    }


defaultDate : Date.Date
defaultDate =
    Date.fromCalendarDate 20 Jan 2020


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
