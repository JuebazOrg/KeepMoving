module SideBarNav exposing (..)

import Bulma.Styled.Components as BC
import Components.Elements as C
import Css exposing (..)
import Html.Styled exposing (Html, i, text)
import Html.Styled.Attributes as A
import Theme.Colors exposing (..)
import Theme.Icons as I


type Msg
    = Noop


viewSideNav : Html msg
viewSideNav =
    BC.menu [ A.css [ padding (px 20) ] ]
        [ BC.menuLabel [] [ text "General" ]
        , BC.menuList []
            [ BC.menuListItemLink False [] [ C.icon [] [ i [ A.class I.add ] [] ], text "Dashboard" ]
            , BC.menuListItemLink False [] [ text "Customers" ]
            ]
        , BC.menuLabel [] [ text "Admin" ]
        , BC.menuList []
            [ BC.menuListItemLink False [] [ text "Dashboard" ]
            , BC.menuListItemLink False [] [ text "Customers" ]
            ]
        ]
