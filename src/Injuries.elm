module Injuries exposing (..)

import Colors exposing (..)
import Components exposing (blueButton, box, tag)
import Css exposing (..)
import Fonts as F
import Html.Styled exposing (..)
import Html.Styled.Attributes as A


type alias Injury =
    { description : String
    , region : Region
    }


type alias Region =
    String


type alias Model =
    List Injury


type Msg
    = Noop


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ h2 [ A.css [ margin (px 0) ] ] [ text "Injuries" ], addInjuryBtn ]
        , div [] <|
            List.map
                (\i -> viewInjury i)
                model
        ]


addInjuryBtn : Html Msg
addInjuryBtn =
    div [ A.css [ maxWidth fitContent ] ] [ blueButton "add" ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    div [ A.css [ box white, maxWidth fitContent, F.primary, marginBottom (px 16) ] ]
        [ span [ A.css [ F.accentuate, color cyanDark, tag cyanLight ] ] [ text injury.region ]
        , p [] [ text injury.description ]
        ]
