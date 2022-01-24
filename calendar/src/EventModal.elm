module EventModal exposing (..)

import Color as C
import Css exposing (..)
import Html.Styled exposing (Html, div, i ,span, text)
import Html.Styled.Attributes as A
import Style as S
import Html.Styled.Events exposing (onClick)
import Event exposing (..)

view : parentMsg -> Maybe Event -> Html parentMsg
view parentMsg maybeEvent =
    case  maybeEvent of 
        Just event -> 
            div
                [ A.class "floating"
                , A.css
                    [ backgroundColor C.white
                    , borderRadius (px 7)
                    , padding (px 10)
                    , minHeight (px 100)
                    , minWidth (px 100)
                    , position fixed
                    , left (pct 50)
                    , top (pct 40)
                    ]
                ]
                [ div [A.css[displayFlex, justifyContent flexEnd]] [ i [ onClick parentMsg ,A.class "fas fa-times", A.css [S.iconStyle, fontSize (em 1.5)] ][]]
                , div [A.css [marginTop (px 10)]][
                    text event.name
                ]

                ]

        Nothing -> 
            div [] []
