module AddInjury exposing (..)

import Components.Components as C
import Components.Modal exposing (modal, modalBody, modalCardTitle, modalHead)
import Css exposing (..)
import Html.Styled exposing (Html, text)
import Html.Styled.Attributes as A
import Theme.Colors as C


myModal : Html msg
myModal =
    modal
        []
        [ modalHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [] ]
        , modalBody []
            [ text "Anything can go here!"
            ]
        ]
