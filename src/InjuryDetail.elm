module InjuryDetail exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Injury exposing (..)


type alias Model =
    Bool


init : Model
init =
    True


view : Model -> Html msg
view model =
    div [] [ text "welcome to injuryDetails" ]
