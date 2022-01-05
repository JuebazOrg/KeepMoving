module InjuryModal exposing (..)

import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Components.Modal exposing (modal, modalBackground, modalCard, modalCardBody, modalCardFoot, modalCardHead, modalCardTitle, modalContent)
import Css exposing (..)
import Html.Styled exposing (Html, div, map, text, span)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Regions exposing (..)


type alias Model =
    { regions : List Region
    , regionSelected : Maybe Region
    , dropdownRegionActive : Bool
    , dropdown : DD.Model Region
    , sideDropDown : DD.Model Side
    }


init : List Region -> Model
init bodyRegion =
    { regions = bodyRegion
    , regionSelected = Nothing
    , dropdownRegionActive = False
    , dropdown = DD.init regionDropdownOptions "Region"
    , sideDropDown = DD.init sideDropDownOptions "Side"
    }


type Msg
    = UpdateRegionChoice Region
    | CloseModal
    | ToggleRegionDropDown
    | Save
    | DropDownMsg (DD.Msg Region)
    | SideDropDownMsg (DD.Msg Side)


update : Model -> Msg -> Model
update model msg =
    case msg of
        UpdateRegionChoice regionValue ->
            { model | regionSelected = Just regionValue, dropdownRegionActive = False }

        ToggleRegionDropDown ->
            { model | dropdownRegionActive = not model.dropdownRegionActive }

        DropDownMsg subMsg ->
            { model | dropdown = DD.update model.dropdown subMsg }

        SideDropDownMsg subMsg ->
            { model | sideDropDown = DD.update model.sideDropDown subMsg }

        _ ->
            model


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
    modal True
        [ A.css [ important <| overflow visible ] ]
        [ modalBackground [] []
        , modalContent [ A.css [ important <| overflow visible ] ]
            [ viewModal model
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
            , viewLocationInput
            , viewDescriptionInput
            ]
        , modalCardFoot [ A.css [ important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
        ]


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = DD.Value region })


sideDropDownOptions : List (DD.Option Side)
sideDropDownOptions =
    sides |> List.map (\side -> { label = fromSide side, value = DD.Value side })
