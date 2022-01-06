module Main exposing (..)

import Browser
import Bulma.Styled.CDN exposing (..)
import Components.Calendar.Calendar as Calendar
import Components.Elements exposing (h4Title, roundButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Injuries exposing (Msg, view)
import Mock.InjuryMock as M
import SideBarNav exposing (Msg, viewSideNav)
import Theme.Colors exposing (..)
import Theme.Icons as I


type alias Model =
    { injuries : Injuries.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            Injuries.init [ M.anInjury, M.anInjury2 ]
    in
    ( { injuries = model }, Cmd.none )


type Msg
    = SideBarNavMsg SideBarNav.Msg
    | InjuriesMsg Injuries.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuriesMsg subMsg ->
            ( { model | injuries = Injuries.update model.injuries subMsg }, Cmd.none )

        SideBarNavMsg subMsg ->
            ( model, Cmd.none )


viewHeader : Html Msg
viewHeader =
    div [ A.css [ backgroundColor white, padding2 (px 10) (px 20), displayFlex, justifyContent spaceBetween, alignItems center ] ]
        [ div [ A.css [ displayFlex, alignItems center ] ]
            [ I.yogaIcon 45, h4Title [] [ text "Keep Moving" ] ]
        , div
            []
            [ roundButton 45 [ text "JB" ] ]
        ]


view : Model -> Html Msg
view model =
    div [ A.css [ displayFlex, flexDirection column, height (vh 100) ] ]
        [ viewHeader
        , div [ A.css [ displayFlex, flex (int 1) ] ]
            [ stylesheet
            , fontAwesomeCDN
            , map SideBarNavMsg viewSideNav
            , div
                [ A.css [ backgroundColor primaryLightest, flex (int 6), padding (px 20) ] ]
                [ map InjuriesMsg (Injuries.view model.injuries) ]
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
