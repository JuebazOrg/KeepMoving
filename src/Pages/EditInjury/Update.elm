module Pages.EditInjury.Update exposing (..)

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
import Id exposing (Id)
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Month(..))


type alias Model =
    { form : Maybe FormModel, navKey : Nav.Key }


type alias FormModel =
    { regionDropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , injuryTypeDropDown : DD.Model InjuryType
    , startDate : DP.Model
    , endDate : DP.Model
    , description : String
    , location : String
    , how : String
    }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { navKey = navKey, form = Nothing }, getInjury id )


initForm : Injury -> Model -> FormModel
initForm injury model =
    { regionDropdown = DD.init regionDropdownOptions "Region" DD.defaultProps
    , sideDropDown = DD.init sideDropDownOptions "Side" DD.defaultProps
    , injuryTypeDropDown = DD.init injuryTypeDropDownOptions "Type" DD.defaultProps
    , startDate = DP.init
    , endDate = DP.init
    , description = injury.description
    , location = ""
    , how = ""
    }


type Msg
    = FormMsg SubMsg
    | InjuryReceived (WebData Injury)
    | InjuryCreated (Result Http.Error ())
    | Save
    | CloseModal


type SubMsg
    = DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | StartDateChange DP.Msg
    | EndDateChange DP.Msg
    | UpdateDescription String
    | UpdateLocation String
    | InjuryTypeDropDownMsg (DD.Msg InjuryType)



update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        InjuryReceived response ->
            case response of
                RemoteData.Success injury ->
                    ( { model | form = Just (initForm injury model) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        FormMsg subMsg ->
            let
                newform =
                    Maybe.map (\f -> updateForm f subMsg) model.form
            in
            ( { model | form = newform }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Route.pushUrl Route.Injuries model.navKey )

                Err error ->
                    ( model, Cmd.none )

        Save ->
            ( model, Cmd.none )

        -- ( model, createNewInjury <| createNewInjuryFromForm model )
        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )


updateForm : FormModel -> SubMsg -> FormModel
updateForm model msg =
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
            { model | startDate = DP.update subMsg model.endDate }

        UpdateDescription content ->
            { model | description = content }

        UpdateLocation content ->
            { model | location = content }


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


-- todo : date from today


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated



-- createNewInjuryFromForm : Model -> NewInjury
-- createNewInjuryFromForm model =
--     { bodyRegion =
--         { region = Maybe.withDefault Other (DD.getSelectedValue model.regionDropdown)
--         , side = DD.getSelectedValue model.sideDropDown
--         }
--     , location = model.location
--     , description = model.description
--     , startDate = Maybe.withDefault defaultDate model.startDate
--     , endDate = model.endDate
--     , how = model.how
--     , injuryType = Maybe.withDefault OtherInjuryType (DD.getSelectedValue model.injuryTypeDropDown)
--     , checkPoints = []
--     }


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
