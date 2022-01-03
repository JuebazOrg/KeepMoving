module Components.Menu exposing (..)

import Bulma.Styled.Components as BC
import Html.Styled as S


menu : List (S.Attribute msg) -> List (BC.MenuPart msg) -> BC.Menu msg
menu attributes messages =
    BC.menu attributes messages


menuListItemLink :
    BC.IsActive
    -> List (S.Attribute msg)
    -> List (S.Html msg)
    -> BC.MenuListItem msg
menuListItemLink isActive attributes messages =
    BC.menuListItemLink isActive attributes messages


menuList : List (S.Attribute msg) -> List (BC.MenuListItem msg) -> BC.MenuPart msg
menuList attributes menuListItem =
    BC.menuList attributes menuListItem


menuLabel : List (S.Attribute msg) -> List (S.Html msg) -> BC.MenuPart msg
menuLabel attributes messages =
    BC.menuLabel attributes messages
