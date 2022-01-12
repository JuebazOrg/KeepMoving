module Navigation.NavBar exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Components.Elements exposing (h4Title, roundButton)
import Css exposing (..)
import Html.Styled exposing (..)


myNavbarBurger : Html msg
myNavbarBurger =
    BC.navbarBurger False
        []
        [ span [] []
        , span [] []
        , span [] []
        ]


viewNavBar : Bool -> Html msg
viewNavBar isOpen =
    BC.fixedNavbar BM.top
        BC.navbarModifiers
        []
        [ BC.navbarBrand []
            myNavbarBurger
            [ BC.navbarItem False
                []
                [ h4Title [] [ text "Keep Moving" ]
                ]
            ]
        , BC.navbarMenu False
            []
            [ BC.navbarStart []
                [ BC.navbarItemLink False [] [ text "Home" ]
                , BC.navbarItemLink False [] [ text "Blog" ]
                , BC.navbarItemLink False [] [ text "Carrots" ]
                , BC.navbarItemLink False [] [ text "About" ]
                ]
            , BC.navbarEnd []
                [ BC.navbarItem False [] [ roundButton 45 [] [ text "JB" ] ] ]
            ]
        ]
