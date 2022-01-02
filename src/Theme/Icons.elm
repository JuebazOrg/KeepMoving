module Theme.Icons exposing (..)

import Css exposing (..)
import Html.Styled as S
import Html.Styled.Attributes as A
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Svg.Attributes exposing (from)
import Svg.Styled exposing (fromUnstyled, svg)
import Theme.Colors exposing (primary)


injuriesIcon : Float -> S.Html msg
injuriesIcon size =
    S.div [ A.css [ height (px size), maxWidth (px size) ] ]
        [ svg
            []
            [ fromUnstyled <| Filled.offline_bolt (Basics.round size) Inherit ]
        ]


yogaIcon : Float -> S.Html msg
yogaIcon size =
    S.img
        [ A.src "yoga.png"
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
