module InjuryModal exposing (..)

import Components.Elements as C
import Components.Form exposing (..)
import Components.Modal exposing (modal, modalBody, modalCardTitle, modalHead)
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Regions exposing (..)


type alias Model =
    { bodyRegions : List BodyRegion, bodyRegionSelected : Maybe BodyRegion, isActive : Bool }


init : List BodyRegion -> Model
init bodyRegions =
    { bodyRegions = bodyRegions, bodyRegionSelected = Nothing, isActive = False }


type Msg
    = UpdateRegionChoice Region
    | CloseModal
    | ToggleRegionDropDown


update : Model -> Msg -> Model
update model msg =
    case msg of
        UpdateRegionChoice regionValue ->
            { model | bodyRegionSelected = Just { region = regionValue, side = Nothing }, isActive = False }

        CloseModal ->
            model

        ToggleRegionDropDown ->
            { model | isActive = not model.isActive }


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
    field []
        [ controlLabel [] [ text "location" ]
        , controlInput defaultControlInputProps [] [] []
        ]


viewModal : Model -> Html Msg
viewModal model =
    modal
        [ A.css [ important <| overflow visible ] ]
        [ modalHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]
        , modalBody [ A.css [ important <| overflow visible ] ]
            [ viewLocationInput
            , viewDescriptionInput
            , myDropdown model
            ]
        ]


myDropdownTrigger : Model -> Html Msg
myDropdownTrigger model =
    dropdownTrigger []
        [ C.addButton
            [ onClick ToggleRegionDropDown ]
            [ text <|
                (model.bodyRegionSelected
                    |> Maybe.map (\br -> fromRegion br.region)
                    |> Maybe.withDefault "Region"
                )
            ]
        ]


myDropdownMenu : Model -> Html Msg
myDropdownMenu model =
    let
        activeRegion =
            model.bodyRegionSelected |> Maybe.map (\br -> br.region)

        dropdownItems =
            bodyRegions
                |> List.map
                    (\item ->
                        case activeRegion of
                            Just active ->
                                if item.region == active then
                                    dropdownItemLink True [ onClick <| UpdateRegionChoice item.region ] [ text (fromRegion item.region) ]

                                else
                                    dropdownItemLink False [ onClick <| UpdateRegionChoice item.region ] [ text (fromRegion item.region) ]

                            _ ->
                                dropdownItemLink False [ onClick <| UpdateRegionChoice item.region ] [ text (fromRegion item.region) ]
                    )
    in
    dropdownMenu []
        []
        dropdownItems


myDropdown : Model -> Html Msg
myDropdown model =
    dropdown model.isActive
        dropdownModifiers
        []
        [ myDropdownTrigger model
        , myDropdownMenu model
        ]
