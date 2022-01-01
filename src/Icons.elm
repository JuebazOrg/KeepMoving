module Icons exposing (..)

import Css exposing (..)
import Html.Styled as S
import Html.Styled.Attributes as A


injuriesIcon : Float -> S.Html msg
injuriesIcon size =
    S.img
        [ A.src "injury.png"
        , A.css
            [ iconStyle size ]
        ]
        []


iconStyle : Float -> Style
iconStyle size =
    batch
        [ width (px size)
        , margin (px 0)
        ]

