module Navigation.NavBar exposing (..)

import Browser.Navigation as Nav
import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Components.Elements exposing (h4Title, lightButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Navigation.Route as Route


type alias Model =
    { navKey : Nav.Key, isOpen : Bool }


init : Nav.Key -> Model
init navKey =
    { navKey = navKey, isOpen = False }


type Msg
    = BurgerMenuTrigger
    | GoToAccount


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToAccount ->
            ( model, Route.pushUrl Route.Account model.navKey )

        BurgerMenuTrigger ->
            ( {model| isOpen = not model.isOpen}, Cmd.none )


myNavbarBurger : Bool -> Html Msg
myNavbarBurger isOpen =
    BC.navbarBurger isOpen
        [ onClick BurgerMenuTrigger ]
        [ span [] []
        , span [] []
        , span [] []
        ]


viewNavBar : Model -> Html Msg
viewNavBar model =
    BC.fixedNavbar BM.top
        BC.navbarModifiers
        []
        [ BC.navbarBrand []
            (myNavbarBurger model.isOpen)
            [ BC.navbarItem False
                []
                [ h4Title [] [ text "Keep Moving" ]
                ]
            ]
        , BC.navbarMenu model.isOpen
            []
            [ BC.navbarStart []
                [ BC.navbarItemLink False [] [ text "Home" ]
                , BC.navbarItemLink False [] [ text "Blog" ]
                , BC.navbarItemLink False [] [ text "Carrots" ]
                , BC.navbarItemLink False [] [ text "About" ]
                ]
            , BC.navbarEnd []
                [ BC.navbarItem False [] [ lightButton [ onClick GoToAccount ] [ text "Account" ] ] ]
            ]
        ]
