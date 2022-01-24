module EventModal exposing (..)

import Color as C
import Css exposing (..)
import Event exposing (..)
import Html.Styled exposing (Html, div, i, span, text)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Style as S


view : parentMsg -> Maybe Event -> Html parentMsg
view parentMsg maybeEvent =
    case maybeEvent of
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
                    ]
                ]
                [ div [ A.css [ displayFlex, justifyContent flexEnd ] ] [ i [ onClick parentMsg, A.class "fas fa-times", A.css [ S.iconStyle, fontSize (em 1.5) ] ] [] ]
                , div [ A.css [ marginTop (px 10) ] ]
                    [ text event.name
                    ]
                ]

        Nothing ->
            div [] []
