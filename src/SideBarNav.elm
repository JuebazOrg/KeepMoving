module SideBarNav exposing (..)

import Colors exposing (..)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Icons as I


type Msg
    = Noop


menuItem : String -> Html Msg
menuItem title =
    div [ A.css [ menuItemStyle ] ]
        [ span [ A.css [ paddingRight (px 10) ] ] [ I.injuriesIcon 35 ]
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
            [ backgroundColor cyan
            , color white
            ]
        , transition
            [ Css.Transitions.backgroundColor 500
            , Css.Transitions.color 300
            ]
        ]


viewSideNav : Html Msg
viewSideNav =
    div [ A.css [ backgroundColor white, flex (int 1) ] ]
        [ div []
            [ menuItem "option A"
            , menuItem "option B"
            , menuItem "option C"
            ]
        ]
