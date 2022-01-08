module InjuryModal exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Components.Modal exposing (modal, modalBackground, modalCard, modalCardBody, modalCardFoot, modalCardHead, modalCardTitle, modalContent)
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (Html, a, div, li, map, span, text, ul)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Id exposing (noId)
import Navigation.Route as Route
import RemoteData exposing (WebData, fromResult)
import Theme.Mobile as M
import Time exposing (Month(..))


type alias Model =
    { regionDropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , startDate : DP.Model
    , description : String
    , location : String
    , navKey : Nav.Key
    }


type alias NewInjury =
    Injury



-- todo: validation  + error + loading


createNewInjuryFromForm : Model -> NewInjury
createNewInjuryFromForm model =
    let
        date =
            Maybe.withDefault (Date.fromCalendarDate 2018 Sep 26) model.startDate
    in
    { bodyRegion =
        { region = Maybe.withDefault Head (DD.getSelectedValue model.regionDropdown)
        , side = DD.getSelectedValue model.sideDropDown
        }
    , location = model.location
    , description = model.description
    , startDate = date
    , endDate = date
    , how = ""
    , injuryType = Sprains
    , id = Id.noId -- todo pas le meme model en creation
    }


init : Nav.Key -> Model
init navKey =
    { regionDropdown = DD.init regionDropdownOptions "Region"
    , sideDropDown = DD.init sideDropDownOptions "Side"
    , startDate = DP.init
    , description = ""
    , location = ""
    , navKey = navKey
    }


type Msg
    = CloseModal
    | Save
    | DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | CalendarMsg DP.Msg
    | InjuryCreated (Result Http.Error ())
    | UpdateDescription String
    | UpdateLocation String


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        DropDownMsg subMsg ->
            ( { model | regionDropdown = DD.update model.regionDropdown subMsg }, Cmd.none )

        SideDropDownMsg subMsg ->
            ( { model | sideDropDown = DD.update model.sideDropDown subMsg }, Cmd.none )

        CalendarMsg subMsg ->
            ( { model | startDate = DP.update subMsg model.startDate }, Cmd.none )

        CloseModal ->
            -- ( model, Route.pushUrl Route.Injuries model.navKey )
            ( model, Cmd.none )

        Save ->
            ( model, createNewInjury (createNewInjuryFromForm model) )

        UpdateDescription content ->
            ( { model | description = content }, Cmd.none )

        UpdateLocation content ->
            ( { model | location = content }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated


viewStartDate : Model -> Html Msg
viewStartDate model =
    field [] [ controlLabel [] [ text "start date" ], map CalendarMsg (DP.view model.startDate) ]


viewDescriptionInput : Html Msg
viewDescriptionInput =
    field []
        [ controlLabel [] [ text "description" ]
        , controlTextArea
            defaultTextAreaProps
            [ onInput UpdateDescription ]
            []
            []
        ]


viewLocationInput : Html Msg
viewLocationInput =
    field [ A.css [ flex (int 3), marginRight (px 10) ] ]
        [ controlLabel [] [ text "location details" ]
        , controlInput defaultControlInputProps [ onInput UpdateLocation ] [] []
        ]


view : Model -> Html Msg
view model =
    div
        [ A.css [ important <| overflow visible ] ]
        [ modalBackground [ A.css [ M.onMobile [ visibility hidden ] ] ] []
        , viewModal model
        ]


viewModal : Model -> Html Msg
viewModal model =
    modalContent
        [ A.css [ displayFlex, flexDirection column, important <| overflow visible, M.onMobile [ important <| maxHeight (pct 100), height (pct 100) ] ] ]
        [ modalCardHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal, A.href "/injuries" ] [] ]
        , modalCardBody [ A.css [ important <| overflow visible ] ]
            [ div [ A.css [ displayFlex, alignItems center ] ]
                [ span [ A.css [ marginRight (px 10) ] ] [ map DropDownMsg (DD.viewDropDown model.regionDropdown) ]
                , map SideDropDownMsg (DD.viewDropDown model.sideDropDown)
                ]
            -- , viewStartDate model
            , viewLocationInput
            , viewDescriptionInput

            -- , viewProgressBar
            ]
        , modalCardFoot [ A.css [ important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
        ]


viewProgressBar : Html msg
viewProgressBar =
    ul [ A.class "steps" ]
        [ li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.class "is-active", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        ]


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = region })


sideDropDownOptions : List (DD.Option Side)
sideDropDownOptions =
    sides |> List.map (\side -> { label = fromSide side, value = side })
