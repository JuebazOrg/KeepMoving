module EventModal exposing (..)

import CalendarColor as C
import Css exposing (..)
import Date as Date exposing (Date)
import Event exposing (..)
import Html.Styled exposing (Html, div, h1, h2, h3, h4, i, span, text)
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
                    , padding (em 1)
                    , minHeight (px 100)
                    , minWidth (px 100)
                    , position fixed
                    ]
                ]
                [ div [ A.css [ displayFlex, justifyContent flexEnd ] ] [ i [ onClick parentMsg, A.class "fa fa-times", A.css [ S.iconStyle, fontSize (em 1.2) ] ] [] ]
                , div [ A.css [ displayFlex, flexDirection column ] ]
                    [ div [ A.css [ displayFlex, alignItems center ] ] [ circleColor event.color, h3 [] [ text event.name ] ]
                    , viewDates event.startDate event.endDate
                    , div [ A.css [ displayFlex, marginTop (em 1) ] ] [ text <| event.description ]
                    ]
                ]

        Nothing ->
            div [] []


circleColor : Color -> Html msg
circleColor colorValue =
    div [ A.css [ height (em 1), width (em 1), borderRadius (em 1), marginRight (em 1), backgroundColor colorValue ] ] []


viewDates : Date -> Maybe Date -> Html msg
viewDates startDate maybeEndDate =
    case maybeEndDate of
        Nothing ->
            span [] [ text <| Date.format "dd MMMM y" startDate ]

        Just endDate ->
            span [] [ text <| Date.format "dd" startDate, text "-", text (Date.format "dd MMMM y " endDate) ]
