module CreateInjury.FormHandler exposing (..)

import Browser.Navigation as Nav
import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Bulma.Styled.Modifiers.Typography as BMT
import Clients.InjuryClient as Client
import Components.Dropdown as DD
import Components.Elements as C
import CreateInjury.Form as Form
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Http
import Navigation.Route as Route
import Time exposing (Month(..))


type alias Model =
    { form : Form.Model, formErrors : Maybe FormError, navKey : Nav.Key }


init : Nav.Key -> Model
init navKey =
    { form = Form.initEmpty
    , formErrors = Nothing
    , navKey = navKey
    }


type Msg
    = CloseForm
    | Save
    | InjuryCreated (Result Http.Error ())
    | FormMsg Form.Msg


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        CloseForm ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        Save ->
            ( { model | formErrors = validateForm model.form }, createIfValid model.form )

        FormMsg sub ->
            ( { model | form = Form.update sub model.form }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Route.pushUrl Route.Injuries model.navKey )

                Err error ->
                    ( { model | formErrors = Just CreateError }, Cmd.none )


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated


type FormError
    = StartDateEmpty
    | RegionEmpty
    | CreateError


toErrorMessage : FormError -> String
toErrorMessage formError =
    case formError of
        StartDateEmpty ->
            "start date cannot be empty"

        RegionEmpty ->
            "region cannot be empty"

        CreateError ->
            "unexpected error occurs while create the injury"


validateForm : Form.Model -> Maybe FormError
validateForm form =
    if form.startDate == Nothing then
        Just StartDateEmpty

    else if form.regionDropdown.selectedOption == Nothing then
        Just RegionEmpty

    else
        Nothing


createIfValid : Form.Model -> Cmd Msg
createIfValid form =
    let
        result =
            buildNewInjury form
    in
    case result of
        Ok newInjury ->
            createNewInjury newInjury

        Err _ ->
            Cmd.none


buildNewInjury : Form.Model -> Result FormError NewInjury
buildNewInjury model =
    case validateForm model of
        Nothing ->
            Ok
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

        Just err ->
            Err err


defaultDate : Date.Date
defaultDate =
    Date.fromCalendarDate 20 Jan 2020


viewErrorMessage : Maybe FormError -> Html msg
viewErrorMessage formErrors =
    span [ BMT.textColor BMT.danger, A.css [ margin (px 10) ] ]
        [ text
            (formErrors
                |> Maybe.map toErrorMessage
                |> Maybe.withDefault ""
            )
        ]


view : Model -> Html Msg
view model =
    div [ A.css [ height (pct 100), displayFlex, flexDirection column, justifyContent spaceBetween ] ]
        [ viewHeader
        , Form.view model.form |> map FormMsg
        , BC.cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ]
            [ viewErrorMessage model.formErrors
            , C.lightButton [ A.css [ marginRight (px 10) ], onClick CloseForm ]
                [ text "cancel" ]
            , C.saveButton [ onClick Save ] [ text "save" ]
            ]
        ]


viewHeader : Html Msg
viewHeader =
    BC.cardHeader [ A.css [ important <| alignItems center ] ]
        [ BC.cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [] [ text "New injury" ] ]
        , C.closeButton [ onClick CloseForm ] []
        ]
