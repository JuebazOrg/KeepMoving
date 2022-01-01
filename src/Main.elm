module Main exposing (..)

import Browser
import Colors exposing (..)
import Components exposing (avatarPlaceHolder, box, primaryButton, tag)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Fonts as F
import Html.Attributes exposing (src)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Icons as I
import SideBarNav exposing (Msg, viewSideNav)


type alias Region =
    String


type alias Injury =
    { description : String
    , region : Region
    }


type alias Model =
    { injuries : List Injury
    }


anInjury : Injury
anInjury =
    { description = "chute en snow dans la neige, coupure au genoux gauche", region = "genoux gauche" }


init : ( Model, Cmd Msg )
init =
    ( { injuries = [ anInjury ] }, Cmd.none )


type Msg
    = SideBarNavMsg SideBarNav.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


viewHeader : Html Msg
viewHeader =
    div [ A.css [ backgroundColor white, padding2 (px 10) (px 20), displayFlex, justifyContent spaceBetween, F.title ] ]
        [ h2 [ A.css [ color cyanDark, margin (px 0) ] ] [ text "Keep \n Tracking" ], avatarPlaceHolder 30 "JB" ]


view : Model -> Html Msg
view model =
    div [ A.css [ displayFlex, flexDirection column, height (vh 100) ] ]
        [ viewHeader
        , div [ A.css [ displayFlex, flex (int 1) ] ]
            [ map SideBarNavMsg viewSideNav
            , div
                [ A.css [ backgroundColor cyanLight, flex (int 4), padding (px 20) ] ]
              <|
                List.map
                    (\i -> viewInjury i)
                    model.injuries
            ]
        ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    div [ A.css [ box white, maxWidth fitContent, F.primary ] ]
        [ span [ A.css [ F.accentuate, color cyanDark, tag cyanLight ] ] [ text injury.region ]
        , p [] [ text injury.description ]
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
