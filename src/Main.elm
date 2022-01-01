module Main exposing (..)

import Browser
import Components exposing (avatarPlaceHolder)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Injuries exposing (Injury, Msg, view)
import Mock.InjuryMock as M
import SideBarNav exposing (Msg, viewSideNav)
import Theme.Colors exposing (..)
import Theme.Fonts as F
import Theme.Icons as I


type alias Model =
    { injuries : List Injury
    }


init : ( Model, Cmd Msg )
init =
    ( { injuries = [ M.anInjury, M.anInjury2 ] }, Cmd.none )


type Msg
    = SideBarNavMsg SideBarNav.Msg
    | InjuriesMsg Injuries.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


viewHeader : Html Msg
viewHeader =
    div [ A.css [ backgroundColor white, padding2 (px 10) (px 20), displayFlex, justifyContent spaceBetween, F.title ] ]
        [ h2 [ A.css [ color cyanDark, margin (px 0), displayFlex, alignItems center ] ] [ I.yogaIcon 45, text "Keep \n Moving" ], avatarPlaceHolder 30 "JB" ]


view : Model -> Html Msg
view model =
    div [ A.css [ displayFlex, flexDirection column, height (vh 100) ] ]
        [ viewHeader
        , div [ A.css [ displayFlex, flex (int 1) ] ]
            [ map SideBarNavMsg viewSideNav
            , div
                [ A.css [ backgroundColor cyanLight, flex (int 6), padding (px 20) ] ]
                [ map InjuriesMsg (Injuries.view model.injuries) ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
