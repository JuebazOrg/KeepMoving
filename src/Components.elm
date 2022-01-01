module Components exposing (..)

import Theme.Colors exposing (..)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Theme.Fonts as F
import Html.Styled as S
import Html.Styled.Attributes as A


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
        , boxShadow5 (px 0) (px 4) (px 8) (px 0) (rgba 0 0 0 0.2)
        , borderRadius (px 6)
        , padding (px 8)
        , color textColor
        , hover
            [ backgroundColor hoverColor
            ]
        , transition
            [ Css.Transitions.backgroundColor 300
            ]
        ]


buttonConstructor : Color -> Color -> Color -> String -> S.Html msg
buttonConstructor primaryColor hoverColor textColor text =
    S.div
        [ A.css
            [ buttonStyle primaryColor hoverColor textColor ]
        ]
        [ S.text text ]


primaryLightButton : String -> S.Html msg
primaryLightButton text =
    buttonConstructor orangeLight orange orangeDark text


primaryButton : String -> S.Html msg
primaryButton text =
    buttonConstructor orangeMedium orangeDark white text


greenLightButton : String -> S.Html msg
greenLightButton text =
    buttonConstructor greenLight green greenDark text


greenButton : String -> S.Html msg
greenButton text =
    buttonConstructor greenMedium greenDark white text


bleuLightButton : String -> S.Html msg
bleuLightButton text =
    buttonConstructor cyanLight cyan cyanDark text


blueButton : String -> S.Html msg
blueButton text =
    buttonConstructor cyanMedium cyanDark white text


rounded : Float -> Style
rounded size =
    batch
        [ width (px size)
        , height (px size)
        , borderRadius (px size)
        ]


avatarPlaceHolder : Float -> String -> S.Html msg
avatarPlaceHolder size initial =
    S.div [ A.css [ buttonStyle white cyanLight cyanDark, rounded size, displayFlex, alignItems center, justifyContent center, F.accentuate ] ] [ S.text initial ]


tag : Color -> Style
tag backgroundValue =
    batch
        [ borderRadius (px 7)
        , backgroundColor backgroundValue
        , padding (px 3)
        , maxWidth fitContent
        ]
