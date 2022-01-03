module SideBarNav exposing (..)

import Components.Components as C
import Components.Menu exposing (menu, menuLabel, menuList, menuListItemLink)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, i, span, text)
import Html.Styled.Attributes as A
import Theme.Colors exposing (..)
import Theme.Icons as I


type Msg
    = Noop


menuItem : String -> Html Msg
menuItem title =
    div [ A.css [ menuItemStyle ] ]
        [ span [ A.css [ paddingRight (px 10) ] ] []
        , text title
        ]


menuItemStyle : Style
menuItemStyle =
    batch
        [ margin2 (px 10) (px 0)
        , backgroundColor white
        , borderRadius (px 7)
        , padding (px 15)
        , displayFlex
        , alignItems center
        , hover
            [ backgroundColor primaryLight
            , color white
            ]
        , transition
            [ Css.Transitions.backgroundColor 500
            , Css.Transitions.color 300
            ]
        ]



-- viewSideNav : Html msg
-- viewSideNav =
--     menu [A.css [padding (px 7)]]
--         [ BC.menuLabel [] [ text "General" ]
--         , BC.menuList []
--             [ BC.menuListItemLink False [] [ text "Dashboard" ]
--             , BC.menuListItemLink False [] [ text "Customers" ]
--             ]
--         , BC.menuLabel [] [ text "Administration" ]
--         , BC.menuList []
--             [ BC.menuListItem []
--                 [ BC.menuListItemLink False [] [ text "Team Settings" ]
--                 ]
--             , BC.menuListItem []
--                 [ BC.menuListItemLink True [] [ text "Manage Your Team" ]
--                 , BC.menuList []
--                     [ BC.menuListItemLink False [] [ text "Members" ]
--                     ]
--                 ]
--             ]
--         ]


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
