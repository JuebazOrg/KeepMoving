module Components.Dropdown exposing (..)

import Components.BulmaElements exposing (..)
import Components.Elements as C
import Css exposing (content, visibility, visible)
import Html.Styled exposing (Attribute, Html, option, text)
import Html.Styled.Events exposing (onClick)


type alias Option =
    { label : String, value : String }


type alias Model =
    { isActive : Bool
    , selectedOption : Maybe Option
    , options : List Option
    }


type Msg
    = ToggleDropdown
    | UpdateOption Option


update : Model -> Msg -> Model
update model msg =
    case msg of
        UpdateOption option ->
            { model | selectedOption = Just option, isActive = False }

        ToggleDropdown ->
            { model | isActive = not model.isActive }


myDropdownTrigger : Model -> Html Msg
myDropdownTrigger model =
    dropdownTrigger []
        [ C.addButton
            [ onClick ToggleDropdown ]
            [ text "Toogle me"
            ]
        ]


myDropdownMenu : Model -> Html Msg
myDropdownMenu model =
    let
        dropdownItems =
            model.options
                |> List.map
                    (\item ->
                        case model.selectedOption of
                            Just active ->
                                if item == active then
                                    dropdownItemLink True [ onClick <| UpdateOption item ] [ text item.label ]

                                else
                                    dropdownItemLink False [ onClick <| UpdateOption item ] [ text item.label ]

                            _ ->
                                dropdownItemLink False [ onClick <| UpdateOption item ] [ text item.label ]
                    )
    in
    dropdownMenu []
        []
        dropdownItems


init : List Option -> Model
init optionsValues =
    { options = optionsValues, isActive = False, selectedOption = Nothing }


myDropdown : Model -> Html Msg
myDropdown model =
    dropdown model.isActive
        dropdownModifiers
        []
        [ myDropdownTrigger model
        , myDropdownMenu model
        ]
