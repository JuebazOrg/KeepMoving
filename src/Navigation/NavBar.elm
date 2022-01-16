module Navigation.NavBar exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Components.Elements exposing (h4Title, roundButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)


type alias Model =
    Bool


init : Model
init =
    False


type Msg
    = BurgerMenuTrigger


update : Msg -> Model -> Model
update msg model =
    not model


myNavbarBurger : Bool -> Html Msg
myNavbarBurger isOpen =
    BC.navbarBurger isOpen
        [ onClick BurgerMenuTrigger ]
        [ span [] []
        , span [] []
        , span [] []
        ]


viewNavBar : Model -> Html Msg
viewNavBar isOpen =
    BC.fixedNavbar BM.top
        BC.navbarModifiers
        []
        [ BC.navbarBrand []
            (myNavbarBurger isOpen)
            [ BC.navbarItem False
                []
                [ h4Title [] [ text "Keep Moving" ]
                ]
            ]
        , BC.navbarMenu isOpen
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
