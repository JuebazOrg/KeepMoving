module Pages.EditInjury.Update exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Cmd.Extra as Cmd
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
import Pages.Injuries.Filters exposing (sideDropdownOptions)
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
    , oldInjury : Injury
    }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { navKey = navKey, form = Nothing }, getInjury id )


initForm : Injury -> FormModel
initForm injury =
    { regionDropdown = initRegionDD injury
    , sideDropDown = initSideDD injury
    , injuryTypeDropDown = initInjuryTypeDD injury
    , startDate = DP.init (Just injury.startDate)
    , endDate = DP.init injury.endDate
    , description = injury.description
    , location = injury.location
    , how = injury.how
    , oldInjury = injury
    }


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


type Msg
    = FormMsg SubMsg
    | InjuryReceived (WebData Injury)
    | InjuryUpdated (WebData Injury)
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
                    Cmd.pure { model | form = Just (initForm injury) }

                _ ->
                    Cmd.pure model

        FormMsg subMsg ->
            let
                newform =
                    Maybe.map (\f -> updateForm f subMsg) model.form
            in
            Cmd.pure { model | form = newform }

        InjuryUpdated res ->
            case res of
                RemoteData.Success injury ->
                    ( model, Route.pushUrl (Route.Injury injury.id) model.navKey )

                _ ->
                    ( model, Cmd.none )

        Save ->
            case model.form of
                Nothing ->
                    ( model, Cmd.none )

                Just form ->
                    ( model, updateInjury <| createNewInjuryFromForm form )

        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )


updateForm : FormModel -> SubMsg -> FormModel
updateForm model msg =
    case msg of
        DropDownMsg subMsg ->
            { model | regionDropdown = DD.update model.regionDropdown subMsg }

        SideDropDownMsg subMsg ->
            -- { model | sideDropDown = DD.update model.sideDropDown subMsg }
            model

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


updateInjury : Injury -> Cmd Msg
updateInjury injury =
    Client.updateInjury injury (RemoteData.fromResult >> InjuryUpdated)


createNewInjuryFromForm : FormModel -> Injury
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
    , checkPoints = model.oldInjury.checkPoints
    , id = model.oldInjury.id
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


selectedToOption : a -> List (DD.Option a) -> Maybe (DD.Option a)
selectedToOption element values =
    values
        |> List.filter (\i -> i.value == element)
        |> List.head
