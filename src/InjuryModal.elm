module InjuryModal exposing (..)

import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Components.Modal exposing (modal, modalBackground, modalCard, modalCardBody, modalCardFoot, modalCardHead, modalCardTitle, modalContent)
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Regions exposing (..)


type alias Model =
    { regions : List Region, regionSelected : Maybe Region, dropdownRegionActive : Bool }


init : List Region -> Model
init bodyRegion =
    { regions = bodyRegion, regionSelected = Nothing, dropdownRegionActive = False }


type Msg
    = UpdateRegionChoice Region
    | CloseModal
    | ToggleRegionDropDown
    | Save


update : Model -> Msg -> Model
update model msg =
    case msg of
        UpdateRegionChoice regionValue ->
            { model | regionSelected = Just regionValue, dropdownRegionActive = False }

        ToggleRegionDropDown ->
            { model | dropdownRegionActive = not model.dropdownRegionActive }

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
        [ controlLabel [] [ text "location" ]
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
            [ div [ A.css [ displayFlex, justifyContent center, alignItems center ] ] [ viewLocationInput, myDropdown model ]
            , viewDescriptionInput
            ]
        , modalCardFoot [ A.css [ important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [] [ text "cancel" ], C.saveButton [ onClick Save ] [ text "save" ] ]
        ]


myDropdownTrigger : Model -> Html Msg
myDropdownTrigger model =
    dropdownTrigger []
        [ C.regionButton
            [ onClick ToggleRegionDropDown ]
            [ text <|
                (model.regionSelected
                    |> Maybe.map (\br -> fromRegion br)
                    |> Maybe.withDefault "Region"
                )
            ]
        ]


myDropdownMenu : Model -> Html Msg
myDropdownMenu model =
    let
        dropdownItems =
            model.regions
                |> List.map
                    (\region ->
                        case model.regionSelected of
                            Just active ->
                                if region == active then
                                    dropdownItemLink True [ onClick <| UpdateRegionChoice region ] [ text (fromRegion region) ]

                                else
                                    dropdownItemLink False [ onClick <| UpdateRegionChoice region ] [ text (fromRegion region) ]

                            _ ->
                                dropdownItemLink False [ onClick <| UpdateRegionChoice region ] [ text (fromRegion region) ]
                    )
    in
    dropdownMenu []
        []
        dropdownItems


myDropdown : Model -> Html Msg
myDropdown model =
    dropdown model.dropdownRegionActive
        dropdownModifiers
        []
        [ myDropdownTrigger model
        , myDropdownMenu model
        ]
