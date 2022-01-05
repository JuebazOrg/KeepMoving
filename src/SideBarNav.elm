module SideBarNav exposing (..)

import Components.Elements as C
import Components.Menu exposing (menu, menuLabel, menuList, menuListItemLink)
import Css exposing (..)
import Html.Styled exposing (Html, i, text)
import Html.Styled.Attributes as A
import Theme.Colors exposing (..)
import Theme.Icons as I


type Msg
    = Noop


viewSideNav : Html msg
viewSideNav =
    menu [ A.css [ padding (px 20) ] ]
        [ menuLabel [] [ text "General" ]
        , menuList []
            [ menuListItemLink False [] [ C.icon [] [ i [ A.class I.add ] [] ], text "Dashboard" ]
            , menuListItemLink False [] [ text "Customers" ]
            ]
        , menuLabel [] [ text "Admin" ]
        , menuList []
            [ menuListItemLink False [] [ text "Dashboard" ]
            , menuListItemLink False [] [ text "Customers" ]
            ]
        ]
