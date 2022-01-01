module Theme.Fonts exposing (..)

import Css exposing (..)


primary : Style
primary =
    batch
        [ fontFamily sansSerif
        , fontSize (px 14)
        , fontWeight normal
        ]


accentuate : Style
accentuate =
    batch
        [ fontFamily sansSerif
        , fontSize (px 15)
        , fontWeight bold
        ]


title : Style
title =
    batch
        [ fontFamily sansSerif
        , fontSize (px 16)
        , fontWeight bold
        ]
