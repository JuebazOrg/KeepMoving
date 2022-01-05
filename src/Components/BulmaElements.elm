module Components.BulmaElements exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers exposing (..)
import Css exposing (fitContent, maxWidth)
import Html.Styled as S
import Html.Styled.Attributes as A


tag : TagProps -> List (S.Html msg) -> S.Html msg
tag tagProps messages =
    BE.tag tagProps [ A.css [ maxWidth fitContent ] ] messages


button : ButtonProps msg -> List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
button buttonProps attributes messages =
    BE.button
        buttonProps
        attributes
        messages


type alias TagProps =
    BE.TagModifiers


defaultTagProps : TagProps
defaultTagProps =
    BE.tagModifiers


type alias ButtonProps msg =
    BE.ButtonModifiers msg


defaultButtonProps : ButtonProps ms
defaultButtonProps =
    BE.buttonModifiers


type alias IconBody msg =
    S.Html msg


type alias DropdownProps =
    BC.DropdownModifiers


dropdownModifiers : DropdownProps
dropdownModifiers =
    BC.dropdownModifiers


dropdown :
    BC.IsActive
    -> BC.DropdownModifiers
    -> List (S.Attribute msg)
    -> List (BC.DropdownContent msg)
    -> BC.Dropdown msg
dropdown isActive attributes contents =
    BC.dropdown isActive attributes contents


dropdownItem :
    BC.IsActive
    -> List (S.Attribute msg)
    -> List (S.Html msg)
    -> BC.DropdownItem msg
dropdownItem isActive attributes messages =
    BC.dropdownItem isActive attributes messages


dropdownItemLink :
    BC.IsActive
    -> List (S.Attribute msg)
    -> List (S.Html msg)
    -> BC.DropdownItem msg
dropdownItemLink isActive attributes messages =
    BC.dropdownItemLink isActive attributes messages


dropdownTrigger : List (S.Attribute msg) -> List (BE.Button msg) -> BC.DropdownContent msg
dropdownTrigger attributes buttons =
    BC.dropdownTrigger attributes buttons


dropdownMenu :
    List (S.Attribute msg)
    -> List (S.Attribute msg)
    -> List (BC.DropdownItem msg)
    -> BC.DropdownContent msg
dropdownMenu attributes dropdownItems =
    BC.dropdownMenu attributes dropdownItems
