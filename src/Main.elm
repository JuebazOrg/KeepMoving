module Main exposing (..)

import Browser
import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Components.Calendar.Calendar as Calendar
import Components.Elements exposing (h4Title, roundButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Injuries exposing (Msg, view)
import SideBarNav exposing (Msg, viewSideNav)
import Theme.Colors exposing (..)
import Theme.Icons as I


type alias Model =
    { injuries : Injuries.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( model, cmd ) =
            Injuries.init  
    in
    ( { injuries = model }, Cmd.map InjuriesMsg cmd )


type Msg
    = SideBarNavMsg SideBarNav.Msg
    | InjuriesMsg Injuries.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuriesMsg subMsg ->
            let
                ( injuryModel, cmd ) =
                    Injuries.update model.injuries subMsg
            in
            ( { model | injuries = injuryModel }, Cmd.map InjuriesMsg cmd )

        SideBarNavMsg subMsg ->
            ( model, Cmd.none )


myNavbarBurger : Html Msg
myNavbarBurger =
    BC.navbarBurger True
        []
        [ span [] []
        , span [] []
        , span [] []
        ]



viewNavBar : Bool -> Html Msg
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
                [ BC.navbarItem False [] [ roundButton 45 [ text "JB" ] ] ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ stylesheet
        , fontAwesomeCDN
        , viewNavBar True

        -- , div [ A.class "is-main-content", A.css [ displayFlex ] ]
        --     [ map SideBarNavMsg viewSideNav
        --     , div
        --         [ A.css [ backgroundColor primaryLightest, flex (int 6), padding (px 15) ] ]
        --         [ map InjuriesMsg (Injuries.view model.injuries) ]
        --     ]
        , div
            [ A.css [ padding (px 20) ] ]
            [ map InjuriesMsg (Injuries.view model.injuries)
            ]
        ]


fontAwesomeCDN =
    node "link"
        [ A.rel "stylesheet"
        , A.href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
