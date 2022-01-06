module InjuryModal exposing (..)

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
import Html.Styled.Events exposing (onClick)
import Regions exposing (..)
import RemoteData exposing (WebData, fromResult)


type alias Model =
    { regions : List Region
    , regionSelected : Maybe Region
    , dropdownRegionActive : Bool
    , dropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    , startDate : DP.Model
    , isOpen : Bool
    }


type alias NewInjury =
    { bodyRegion : BodyRegion
    , description : String
    , location : String
    }



-- todo: validation + creer a partir du form


createNewInjuryFromForm : Model -> NewInjury
createNewInjuryFromForm model =
    { bodyRegion = { region = Head, side = Nothing }
    , location = "yeux"
    , description = "recu de la glace dans l'oeil"
    }


initOpen : Model -> Model
initOpen model =
    { model | isOpen = True }


initClosed : Model
initClosed =
    { regions = Regions.regions
    , regionSelected = Nothing
    , dropdownRegionActive = False
    , dropdown = DD.init regionDropdownOptions "Region"
    , sideDropDown = DD.init sideDropDownOptions "Side"
    , startDate = DP.init
    , isOpen = False
    }


type Msg
    = UpdateRegionChoice Region
    | CloseModal
    | ToggleRegionDropDown
    | Save
    | DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)
    | CalendarMsg DP.Msg
    | OpenModal
    | InjuryCreated (WebData ())


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        UpdateRegionChoice regionValue ->
            ( { model | regionSelected = Just regionValue, dropdownRegionActive = False }, Cmd.none )

        ToggleRegionDropDown ->
            ( { model | dropdownRegionActive = not model.dropdownRegionActive }, Cmd.none )

        DropDownMsg subMsg ->
            ( { model | dropdown = DD.update model.dropdown subMsg }, Cmd.none )

        SideDropDownMsg subMsg ->
            ( { model | sideDropDown = DD.update model.sideDropDown subMsg }, Cmd.none )

        CalendarMsg subMsg ->
            ( { model | startDate = DP.update subMsg model.startDate }, Cmd.none )

        CloseModal ->
            ( initClosed, Cmd.none )

        OpenModal ->
            ( { initClosed | isOpen = True }, Cmd.none )

        Save ->
            ( model, createNewInjury (createNewInjuryFromForm model) )

        InjuryCreated _ ->
            ( model, Cmd.none )


createNewInjury : NewInjury -> Cmd Msg
createNewInjury newInjury =
    Client.createInjury newInjury (fromResult >> InjuryCreated)


viewStartDate : Model -> Html Msg
viewStartDate model =
    field [] [ controlLabel [] [ text "start date" ], map CalendarMsg (DP.view model.startDate) ]


viewDescriptionInput : Html msg
viewDescriptionInput =
    field []
        [ controlLabel [] [ text "description" ]
        , controlTextArea
            defaultTextAreaProps
            []
            []
            []
        ]


viewLocationInput : Html msg
viewLocationInput =
    field [ A.css [ flex (int 3), marginRight (px 10) ] ]
        [ controlLabel [] [ text "location details" ]
        , controlInput defaultControlInputProps [] [] []
        ]


view : Model -> Html Msg
view model =
    div []
        [ C.addButton [ onClick OpenModal ]
            [ text "Injury" ]
        , modal
            model.isOpen
            [ A.css [ important <| overflow visible ] ]
            [ modalBackground [] []
            , modalContent [ A.css [ important <| overflow visible ] ]
                [ viewModal model
                ]
            ]
        ]


viewModal : Model -> Html Msg
viewModal model =
    modalCard
        [ A.css [ important <| overflow visible ] ]
        [ modalCardHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]
        , modalCardBody [ A.css [ important <| overflow visible ] ]
            [ div [ A.css [ displayFlex, alignItems center ] ]
                [ span [ A.css [ marginRight (px 10) ] ] [ map DropDownMsg (DD.viewDropDown model.dropdown) ]
                , map SideDropDownMsg (DD.viewDropDown model.sideDropDown)
                ]
            , viewStartDate model
            , viewLocationInput
            , viewDescriptionInput
            , viewProgressBar
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
        |> List.map (\region -> { label = fromRegion region, value = DD.Value region })


sideDropDownOptions : List (DD.Option Side)
sideDropDownOptions =
    sides |> List.map (\side -> { label = fromSide side, value = DD.Value side })
