module Components.Dropdown exposing (..)

import Components.BulmaElements exposing (..)
import Components.Elements as C
import Html.Styled exposing (Html, a, option, text)
import Html.Styled.Events exposing (onClick)
import Regions exposing (Side(..))


type alias Option a =
    { label : String, value : a }


type alias Model a =
    { isActive : Bool
    , selectedOption : Maybe (Option a)
    , options : List (Option a)
    , defaultTitle : String
    }


type Msg a
    = ToggleDropdown
    | UpdateOption (Option a)
    | Reset


getSelectedValue : Model a -> Maybe a
getSelectedValue model =
    model.selectedOption
        |> Maybe.map
            (\option -> option.value)


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

        Reset ->
            { model | selectedOption = Nothing, isActive = False }


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
        (dropdownItemLink
            False
            [ onClick <| Reset ]
            [ text model.defaultTitle ]
            :: dropdownItems
        )


viewDropDown : Model a -> Html (Msg a)
viewDropDown model =
    dropdown model.isActive
        dropdownModifiers
        []
        [ myDropdownTrigger model
        , myDropdownMenu model
        ]
