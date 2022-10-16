module EditInjury.EditInjury exposing (..)

-- import CreateInjury.Form as Form

import Browser.Navigation as Nav
import Bulma.Styled.Components as BC
import Clients.InjuryClient as Client
import Cmd.Extra as Cmd
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Components.Elements as C
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import EditInjury.Form as Form
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Time exposing (Month(..))


type alias Model =
    { form : Maybe Form.Model, navKey : Nav.Key, injury : WebData Injury }


init : Nav.Key -> String -> ( Model, Cmd Msg )
init navKey id =
    ( { navKey = navKey, form = Nothing, injury = RemoteData.Loading }, getInjury id )


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
                    Cmd.pure { model | form = Just (Form.init injury), injury = response }

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
                            ( model, updateInjury <| createNewInjuryFromForm form injury )

                        _ ->
                            ( model, Cmd.none )

        CloseModal ->
            case model.injury of
                RemoteData.Success injury ->
                    ( model, Route.pushUrl (Route.Injury injury.id) model.navKey )

                _ ->
                    ( model, Cmd.none )


getInjury : String -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


updateInjury : Injury -> Cmd Msg
updateInjury injury =
    Client.updateInjury injury (RemoteData.fromResult >> InjuryUpdated)


createNewInjuryFromForm : Form.Model -> Injury -> Injury
createNewInjuryFromForm model oldInjury =
    { bodyRegion =
        { region = Maybe.withDefault Other model.region.value
        , side = model.side.value
        }
    , location = model.location
    , description = model.description
    , startDate = Maybe.withDefault defaultDate model.startDate
    , endDate = model.endDate
    , how = model.how
    , injuryType = Maybe.withDefault OtherInjuryType model.injuryType.value
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
        , BC.cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [ A.css [ marginRight (px 10) ], onClick CloseModal ] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
        ]


viewHeader : Html Msg
viewHeader =
    BC.cardHeader [ A.css [ important <| alignItems center ] ] [ BC.cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ C.h3Title [] [ text "New injury" ] ], C.closeButton [ onClick CloseModal ] [] ]
