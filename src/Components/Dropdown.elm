module Components.Dropdown exposing (..)

import Components.BulmaElements exposing (..)
import Components.Elements as C
import Html.Styled exposing (Html, option, text)
import Html.Styled.Events exposing (onClick)


type DropDownOption a
    = Value a


type alias Option a =
    { label : String, value : DropDownOption a }


type alias Model a =
    { isActive : Bool
    , selectedOption : Maybe (Option a)
    , options : List (Option a)
    , defaultTitle : String
    }


type Msg a
    = ToggleDropdown
    | UpdateOption (Option a)

init : List (Option a) -> String -> Model a
init optionsValues title =
    { options = optionsValues, isActive = False, selectedOption = Nothing, defaultTitle = title }


update : Model a -> Msg a -> Model a
update model msg =
    case msg of
        UpdateOption option ->
            { model | selectedOption = Just option, isActive = False }

        ToggleDropdown ->
            { model | isActive = not model.isActive }


myDropdownTrigger : Model a -> Html (Msg a)
myDropdownTrigger model =
    let
        title =
            model.selectedOption
                |> Maybe.map (\option -> option.label)
                |> Maybe.withDefault model.defaultTitle
    in
    dropdownTrigger []
        [ C.dropDownButton
            [ onClick ToggleDropdown ]
            [ text title
            ]
        ]


myDropdownMenu : Model a -> Html (Msg a)
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



viewDropDown : Model a -> Html (Msg a)
viewDropDown model =
    dropdown model.isActive
        dropdownModifiers
        []
        [ myDropdownTrigger model
        , myDropdownMenu model
        ]
