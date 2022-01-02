module ComponentsV2 exposing (..)

import Bulma.BulmaElements exposing (..)
import Css exposing (borderRadius, fitContent, height, maxWidth, ms, px, width)
import Html.Styled as S
import Html.Styled.Attributes as A


roundButton : Float -> List (S.Html msg) -> S.Html msg
roundButton size messages =
    let
        buttonP =
            { defaultProps | rounded = True }
    in
    button buttonP [ A.css [ width (px size), height (px size), borderRadius (px size) ] ] messages
