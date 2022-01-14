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
import Pages.EditInjury.Form as EF
import Pages.Injuries.Filters exposing (sideDropdownOptions)
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Month(..))


type alias Model =
    { form : Maybe EF.Model, navKey : Nav.Key }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { navKey = navKey, form = Nothing }, getInjury id )


initForm : Injury -> EF.Model
initForm injury =
    EF.init injury


type Msg
    = FormMsg EF.Msg
    | InjuryReceived (WebData Injury)
    | InjuryUpdated (WebData Injury)
    | Save
    | CloseModal


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
                    model.form |> Maybe.map (\form -> EF.update subMsg form)
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
                    -- ( model, updateInjury <| createNewInjuryFromForm form )
                    ( model, Cmd.none )

        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )



-- updateForm : FormModel -> SubMsg -> FormModel
-- updateForm model msg =
--     case msg of
--         DropDownMsg subMsg ->
--             { model | regionDropdown = DD.update model.regionDropdown subMsg }
--         SideDropDownMsg subMsg ->
--             -- { model | sideDropDown = DD.update model.sideDropDown subMsg }
--             model
--         InjuryTypeDropDownMsg subMsg ->
--             { model | injuryTypeDropDown = DD.update model.injuryTypeDropDown subMsg }
--         StartDateChange subMsg ->
--             { model | startDate = DP.update subMsg model.startDate }
--         EndDateChange subMsg ->
--             { model | startDate = DP.update subMsg model.endDate }
--         UpdateDescription content ->
--             { model | description = content }
--         UpdateLocation content ->
--             { model | location = content }


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)



-- todo : date from today


updateInjury : Injury -> Cmd Msg
updateInjury injury =
    Client.updateInjury injury (RemoteData.fromResult >> InjuryUpdated)


createNewInjuryFromForm : EF.Model -> Injury -> Injury
createNewInjuryFromForm model oldInjury =
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
    , checkPoints = oldInjury.checkPoints
    , id = oldInjury.id
    }


defaultDate : Date.Date
defaultDate =
    Date.fromCalendarDate 20 Jan 2020
