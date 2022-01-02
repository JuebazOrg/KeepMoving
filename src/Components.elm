module Components exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Elements exposing (icon, tag, tagModifiers)
import Bulma.Styled.Modifiers as BM
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled as S
import Html.Styled.Attributes as A
import Theme.Colors exposing (..)
import Theme.Fonts as F
import Theme.Icons as I


box : Color -> Style
box backgroundColorValue =
    batch
        [ displayFlex
        , flexDirection column
        , alignItems stretch
        , justifyContent center
        , padding (px 10)
        , backgroundColor backgroundColorValue
        , boxShadow5 (px 0) (px 4) (px 8) (px 0) (rgba 0 0 0 0.2)
        , borderRadius (px 6)
        , hover
            [ boxShadow5 (px 0) (px 8) (px 14) (px 0) (rgba 0 0 0 0.2)
            ]
        ]


buttonStyle : Color -> Color -> Color -> Style
buttonStyle primaryColor hoverColor textColor =
    batch
        [ backgroundColor primaryColor
        , boxShadow5 (px 0) (px 4) (px 8) (px 0) (rgba 0 0 0 0.4)
        , borderRadius (px 6)
        , padding (px 8)
        , color textColor
        , displayFlex
        , alignItems center
        , hover
            [ backgroundColor hoverColor
            ]
        , transition
            [ Css.Transitions.backgroundColor 300
            ]
        ]


iconButtonConstructor : I.Icon msg -> Float -> Color -> Color -> Color -> String -> S.Html msg
iconButtonConstructor iconName size primaryColor hoverColor textColor text =
    let
        icon =
            I.dynamicIcon iconName size primaryLight primaryLighter
    in
    S.div
        [ A.css
            [ buttonStyle primaryColor hoverColor textColor ]
        ]
        [ icon, S.text text ]


buttonConstructor : Color -> Color -> Color -> String -> S.Html msg
buttonConstructor primaryColor hoverColor textColor text =
    S.div
        [ A.css
            [ buttonStyle primaryColor hoverColor textColor ]
        ]
        [ S.text text ]


primaryLightButton : String -> S.Html msg
primaryLightButton text =
    buttonConstructor primaryLighter primaryLight primaryDarker text


primaryButton : String -> S.Html msg
primaryButton text =
    buttonConstructor primary primaryDarker white text


secondaryLightButton : String -> S.Html msg
secondaryLightButton text =
    buttonConstructor secondaryLighter secondaryLight secondaryDarker text


secondaryButton : String -> S.Html msg
secondaryButton text =
    buttonConstructor secondary secondaryDarker secondaryDarkest text


rounded : Float -> Style
rounded size =
    batch
        [ width (px size)
        , height (px size)
        , borderRadius (px size)
        ]


avatarPlaceHolder : Float -> String -> S.Html msg
avatarPlaceHolder size initial =
    S.div [ A.css [ buttonStyle white primaryLighter primaryDarker, rounded size, displayFlex, alignItems center, justifyContent center, F.accentuate ] ] [ S.text initial ]


tag : String -> BM.Size -> BM.Color -> S.Html msg
tag content sizeValue colorValue =
    Bulma.Styled.Elements.tag { tagModifiers | color = colorValue, size = sizeValue }
        [A.css [maxWidth fitContent]]
        [ S.text content
        ]
