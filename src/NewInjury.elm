module NewInjury exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Calendar.DatePicker as DP
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (Html, a, div, input, li, map, span, text, ul)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Id exposing (noId)
import Material.Icons exposing (create)
import Navigation.Route as Route
import RemoteData exposing (WebData, fromResult)
import Theme.Mobile as M
import Time exposing (Month(..))


type alias Model =
    { regionDropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , injuryTypeDropDown : DD.Model InjuryType
    , startDate : DP.Model
    , description : String
    , location : String
    , navKey : Nav.Key
    }



-- todo: validation  + error + loading


createNewInjuryFromForm : Model -> NewInjury
createNewInjuryFromForm model =
    let
        date =
            Maybe.withDefault (Date.fromCalendarDate 2018 Sep 26) model.startDate.date
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
    }


init : Nav.Key -> Model
init navKey =
    { regionDropdown = DD.init regionDropdownOptions "Region"
    , sideDropDown = DD.init sideDropDownOptions "Side"
    , injuryTypeDropDown = DD.init injuryTypeDropDownOptions "Injury type"
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

        CalendarMsg subMsg ->
            ( { model | startDate = DP.update subMsg model.startDate }, Cmd.none )

        CloseModal ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        Save ->
            ( model, createNewInjury <| createNewInjuryFromForm model )

        UpdateDescription content ->
            ( { model | description = content }, Cmd.none )

        UpdateLocation content ->
            ( { model | location = content }, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( model, Route.pushUrl Route.Injuries model.navKey )

                Err error ->
                    ( model, Cmd.none )


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury InjuryCreated


viewStartDate : Model -> Html Msg
viewStartDate model =
    field [] [ controlLabel [] [ text "Start date" ], map CalendarMsg (DP.view model.startDate) ]


viewEndDate : Model -> Html Msg
viewEndDate model =
    field [ A.css [ marginLeft (px 10) ] ] [ controlLabel [] [ text "End date" ], map CalendarMsg (DP.view model.startDate) ]


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


viewHowInput : Html Msg
viewHowInput =
    field []
        [ controlLabel [] [ text "how it happen" ]
        , controlTextArea
            defaultTextAreaProps
            []
            []
            []
        ]


viewLocationInput : Html Msg
viewLocationInput =
    field [ A.css [ flex (int 3), marginRight (px 10) ] ]
        [ controlLabel [] [ text "location details" ]
        , controlInput defaultControlInputProps [ onInput UpdateLocation ] [] []
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    cardHeader [] [ cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]


view : Model -> Html Msg
view model =
    div
        [ A.class "newInjury", A.css [ height (pct 100), displayFlex, flexDirection column, justifyContent spaceBetween ] ]
        [ viewHeader model
        , cardContent [ A.css [ flex (int 1) ] ]
            [ div [ A.css [ displayFlex, alignItems center ] ]
                [ span [ A.css [ marginRight (px 10) ] ] [ map DropDownMsg (DD.viewDropDown model.regionDropdown) ]
                , span [ A.css [ marginRight (px 10) ] ] [ map SideDropDownMsg (DD.viewDropDown model.sideDropDown) ]
                , map InjuryTypeDropDownMsg (DD.viewDropDown model.injuryTypeDropDown)
                ]

            -- , viewStartDate model
            , viewLocationInput
            , viewDescriptionInput
            , viewHowInput
            , span [ A.css [ displayFlex, M.onMobile [ flexDirection column ] ] ]
                [ viewStartDate model
                , viewEndDate model
                ]

            -- , viewProgressBar
            ]
        , cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [ A.css [ marginRight (px 10) ] ] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
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


injuryTypeDropDownOptions : List (DD.Option InjuryType)
injuryTypeDropDownOptions =
    injuryTypes |> List.map (\injuryType -> { label = injuryTypeToString injuryType, value = injuryType })
