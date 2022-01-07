module InjuryModal exposing (..)

import Browser.Navigation as Navigation
import Clients.InjuryClient as Client
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Components.Modal exposing (modal, modalBackground, modalCard, modalCardBody, modalCardFoot, modalCardHead, modalCardTitle, modalContent)
import Css exposing (..)
import Date as Date
import Html.Styled exposing (Html, a, div, li, map, span, text, ul)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Injury exposing (..)
import Regions exposing (..)
import RemoteData exposing (WebData, fromResult)
import Theme.Mobile as M
import Time exposing (Month(..))


type alias Model =
    { regionDropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , startDate : DP.Model
    , isOpen : Bool
    , description : String
    , location : String
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
    , id = 3 -- todo pas le meme model en creation
    }


initClosed : Model
initClosed =
    { regionDropdown = DD.init regionDropdownOptions "Region"
    , sideDropDown = DD.init sideDropDownOptions "Side"
    , startDate = DP.init
    , isOpen = False
    , description = ""
    , location = ""
    }


type Msg
    = CloseModal
    | OpenModal
    | Save
    | DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | CalendarMsg DP.Msg
    | InjuryCreated (Result Http.Error ())
    | UpdateDescription String
    | UpdateLocation String


update : Model -> Msg -> Cmd msg -> ( Model, Cmd Msg, Cmd msg )
update model msg onSuccess =
    case msg of
        DropDownMsg subMsg ->
            ( { model | regionDropdown = DD.update model.regionDropdown subMsg }, Cmd.none, Cmd.none )

        SideDropDownMsg subMsg ->
            ( { model | sideDropDown = DD.update model.sideDropDown subMsg }, Cmd.none, Cmd.none )

        CalendarMsg subMsg ->
            ( { model | startDate = DP.update subMsg model.startDate }, Cmd.none, Cmd.none )

        CloseModal ->
            ( initClosed, Cmd.none, Cmd.none )

        OpenModal ->
            ( { initClosed | isOpen = True }, Cmd.none, Cmd.none )

        Save ->
            ( model, createNewInjury (createNewInjuryFromForm model), Cmd.none )

        UpdateDescription content ->
            ( { model | description = content }, Cmd.none, Cmd.none )

        UpdateLocation content ->
            ( { model | location = content }, Cmd.none, Cmd.none )

        InjuryCreated res ->
            case res of
                Ok _ ->
                    ( initClosed, Cmd.none, onSuccess )

                Err error ->
                    ( model, Cmd.none, Cmd.none )


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
    div []
        [ C.addButton [ onClick OpenModal ]
            [ text "Injury" ]
        , modal
            model.isOpen
            [ A.css [ important <| overflow visible ] ]
            [ modalBackground [ A.css [ M.onMobile [ visibility hidden ] ] ] []
            , viewModal model
            ]
        ]


viewModal : Model -> Html Msg
viewModal model =
    modalContent
        [ A.css [ displayFlex, flexDirection column, important <| overflow visible, M.onMobile [ important <| maxHeight (pct 100), height (pct 100) ] ] ]
        [ modalCardHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]
        , modalCardBody [ A.css [ important <| overflow visible ] ]
            [ div [ A.css [ displayFlex, alignItems center ] ]
                [ span [ A.css [ marginRight (px 10) ] ] [ map DropDownMsg (DD.viewDropDown model.regionDropdown) ]
                , map SideDropDownMsg (DD.viewDropDown model.sideDropDown)
                ]
            , viewStartDate model
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
