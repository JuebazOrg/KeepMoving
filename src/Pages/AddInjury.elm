module Pages.AddInjury exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (cardFooter, cardHeader, cardTitle)
import Components.Dropdown as DD
import Components.Elements as C
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Http
import Navigation.Route as Route
import Pages.InjuryForm as Form
import Time exposing (Month(..))


type alias Model =
    { form : Form.Model, navKey : Nav.Key }



-- passer la navkey dans le update a la place


init : Nav.Key -> Model
init navKey =
    { form = Form.initEmpty
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
            ( model, createNewInjury <| createNewInjuryFromForm model.form )

        FormMsg sub ->
            ( { model | form = Form.update sub model.form }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Route.pushUrl Route.Injuries model.navKey )

                Err error ->
                    ( model, Cmd.none )


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated

-- todo: fct build dans le formulaire
createNewInjuryFromForm : Form.Model -> NewInjury
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


view : Model -> Html Msg
view model =
    div [ A.css [ height (pct 100), displayFlex, flexDirection column, justifyContent spaceBetween ] ]
        [ viewHeader
        , Form.view model.form |> map FormMsg
        , cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ]
            [ C.lightButton [ A.css [ marginRight (px 10) ], onClick CloseForm ]
                [ text "cancel" ]
            , C.saveButton [ onClick Save ] [ text "save" ]
            ]
        ]


viewHeader : Html Msg
viewHeader =
    cardHeader [ A.css [ important <| alignItems center ] ]
        [ cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [] [ text "New injury" ] ]
        , C.closeButton [ onClick CloseForm ] []
        ]
