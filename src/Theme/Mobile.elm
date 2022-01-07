module Theme.Mobile exposing (..)

import Css exposing (..)
import Css.Media as M



onMobile : List Style -> Style
onMobile =
    M.withMedia [ M.only M.screen [ M.maxWidth (px 450) ] ]


onTinyScreen : List Style -> Style
onTinyScreen =
    M.withMedia [ M.only M.screen [ M.maxWidth (px 340) ] ]


onBigScreen : List Style -> Style
onBigScreen =
    M.withMedia [ M.only M.screen [ M.minWidth (px 450) ] ]


onVeryBigScreen : List Style -> Style
onVeryBigScreen =
    M.withMedia [ M.only M.screen [ M.minWidth (px 1600) ] ]
