module Components.Form exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Form as BF
import Css exposing (content)
import Html.Styled exposing (Attribute, Html, option, text)
import Html.Styled.Attributes as A


type alias ControlInputProps msg =
    BF.ControlInputModifiers msg


defaultControlInputProps : ControlInputProps msg
defaultControlInputProps =
    BF.controlInputModifiers


controlInput :
    BF.ControlInputModifiers msg
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> BF.Control msg
controlInput props controlAttributes inputAttributes messages =
    BF.controlInput props controlAttributes inputAttributes messages


field : List (Attribute msg) -> List (BF.Control msg) -> BF.Field msg
field attributes controls =
    BF.field attributes controls


controlLabel : List (Attribute msg) -> List (Html msg) -> BF.Control msg
controlLabel attributes messages =
    BF.controlLabel attributes messages


type alias ControlTextAreaProps =
    BF.ControlTextAreaModifiers


defaultTextAreaProps : ControlTextAreaProps
defaultTextAreaProps =
    BF.controlTextAreaModifiers


controlTextArea :
    BF.ControlTextAreaModifiers
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> BF.Control msg
controlTextArea controlAttributes inputAttributes messages =
    BF.controlTextArea controlAttributes inputAttributes messages


type alias ControlSelectModifiers msg =
    BF.ControlSelectModifiers msg


controlSelectDefaultProps : ControlSelectModifiers msg
controlSelectDefaultProps =
    BF.controlSelectModifiers


controlSelect :
    BF.ControlSelectModifiers msg
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (BF.Option msg)
    -> BF.Control msg
controlSelect controlAttributes selectAttributes options =
    BF.controlSelect controlAttributes selectAttributes options


anOption : ( String, String ) -> List (Attribute msg) -> Html msg
anOption ( key, val ) attributes =
    option (A.value val :: attributes)
        [ text key
        ]


type alias DropdownProps =
    BC.DropdownModifiers


dropdownModifiers : DropdownProps
dropdownModifiers =
    BC.dropdownModifiers


dropdown :
    BC.IsActive
    -> BC.DropdownModifiers
    -> List (Attribute msg)
    -> List (BC.DropdownContent msg)
    -> BC.Dropdown msg
dropdown isActive attributes contents =
    BC.dropdown isActive attributes contents


dropdownItem :
    BC.IsActive
    -> List (Attribute msg)
    -> List (Html msg)
    -> BC.DropdownItem msg
dropdownItem isActive attributes messages =
    BC.dropdownItem isActive attributes messages


dropdownItemLink :
    BC.IsActive
    -> List (Attribute msg)
    -> List (Html msg)
    -> BC.DropdownItem msg
dropdownItemLink isActive attributes messages =
    BC.dropdownItemLink isActive attributes messages


dropdownTrigger : List (Attribute msg) -> List (BE.Button msg) -> BC.DropdownContent msg
dropdownTrigger attributes buttons =
    BC.dropdownTrigger attributes buttons


dropdownMenu :
    List (Attribute msg)
    -> List (Attribute msg)
    -> List (BC.DropdownItem msg)
    -> BC.DropdownContent msg
dropdownMenu attributes dropdownItems =
    BC.dropdownMenu attributes dropdownItems


controlCheckBox :
    BF.IsDisabled
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> BF.Control msg
controlCheckBox isDisabled controlAttributes labelAttribute checkBoxAttributes =
    BF.controlCheckBox isDisabled controlAttributes labelAttribute checkBoxAttributes
