module Components.Dropdown2 exposing (..)

import Bulma.Styled.Components as BC
import Components.Dropdown exposing (Model)
import Components.Elements as E
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Maybe


type alias Option a =
    { value : Maybe a, label : String }


type alias Model a =
    { value : Maybe a, isOpen : Bool }


type Msg a
    = ToggleDropdown
    | UpdateOption a


update : Model a -> Msg (Maybe a) -> Model a
update model msg =
    case msg of
        UpdateOption value ->
            { model | value = value, isOpen = False }

        ToggleDropdown ->
            { model | isOpen = not model.isOpen }


init : Model a
init =
    { value = Nothing, isOpen = False }


view : Model a -> List (Option a) -> String -> Html (Msg (Maybe a))
view model options title =
    let
        selectedOption =
            findOption (\i -> i.value == model.value) options
    in
    BC.dropdown model.isOpen
        BC.dropdownModifiers
        []
        [ myDropdownTrigger title selectedOption, myDropdownMenu model (emptyOption :: options) ]


myDropdownTrigger : String -> Maybe (Option a) -> Html (Msg (Maybe a))
myDropdownTrigger title selection =
    let
        displayedTitle =
            selection
                |> Maybe.map (\option -> option.label)
                |> Maybe.withDefault title
    in
    BC.dropdownTrigger []
        [ E.dropDownButton
            [ onClick ToggleDropdown ]
            [ text displayedTitle
            ]
        ]


myDropdownMenu : Model a -> List (Option a) -> Html (Msg (Maybe a))
myDropdownMenu model menu =
    BC.dropdownMenu [] [] <| List.map (toMenuItem model) menu


toMenuItem : Model a -> Option a -> BC.DropdownItem (Msg (Maybe a))
toMenuItem model option =
    BC.dropdownItemLink (model.value == option.value)
        [ onClick (UpdateOption option.value) ]
        [ text option.label ]


findOption : (Option b -> Bool) -> List (Option b) -> Maybe (Option b)
findOption predicat items =
    items
        |> List.filter predicat
        |> List.head


emptyOption : Option a
emptyOption =
    { value = Nothing, label = "None" }
