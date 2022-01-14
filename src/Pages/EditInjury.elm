module Pages.EditInjury exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Cmd.Extra as Cmd
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Id exposing (Id)
import Navigation.Route as Route
import Pages.InjuryForm as Form
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Month(..))


type alias Model =
    { form : Maybe Form.Model, navKey : Nav.Key, injury : WebData Injury }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { navKey = navKey, form = Nothing, injury = RemoteData.Loading }, getInjury id )


initForm : Injury -> Form.Model
initForm injury =
    Form.init injury


type Msg
    = FormMsg Form.Msg
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
                    Cmd.pure { model | form = Just (initForm injury), injury = response }

                _ ->
                    Cmd.pure model

        FormMsg subMsg ->
            let
                newform =
                    model.form |> Maybe.map (\form -> Form.update subMsg form)
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
                    case model.injury of
                        RemoteData.Success injury ->
                            let
                                log =
                                    Debug.log "injury" injury
                            in
                            ( model, updateInjury <| createNewInjuryFromForm form injury )

                        _ ->
                            ( model, Cmd.none )

        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


updateInjury : Injury -> Cmd Msg
updateInjury injury =
    Client.updateInjury injury (RemoteData.fromResult >> InjuryUpdated)


createNewInjuryFromForm : Form.Model -> Injury -> Injury
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


view : Model -> Html Msg
view model =
    model.form
        |> Maybe.map (\f -> viewContent f)
        |> Maybe.withDefault C.empty


viewContent : Form.Model -> Html Msg
viewContent formModel =
    div [ A.css [ height (pct 100), displayFlex, flexDirection column, justifyContent spaceBetween ] ]
        [ viewHeader
        , Form.view formModel |> map FormMsg
        , cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [ A.css [ marginRight (px 10) ], onClick CloseModal ] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
        ]


viewHeader : Html Msg
viewHeader =
    cardHeader [ A.css [ important <| alignItems center ] ] [ cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ C.h3Title [] [ text "New injury" ] ], C.closeButton [ onClick CloseModal ] [] ]
