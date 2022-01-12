module Components.SlidingPanel exposing (..)

import Bulma.Styled.Elements exposing (box)
import Components.Card as Card
import Components.Dropdown exposing (Msg)
import Components.Elements as C
import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Theme.Icons as I


view : Bool -> Float -> List (Html msg) -> Html msg
view isOpen height content =
    if isOpen then
        box [ A.class "slidein open", A.css [ styled height ] ] content

    else
        box [ A.class "slidein" ] content


styled : Float -> Style
styled openPercentage =
    batch
        [ important <| borderRadius (Css.em 3)
        , important <| top (pct openPercentage)
        ]
