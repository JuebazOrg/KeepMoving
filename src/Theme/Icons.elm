module Theme.Icons exposing (Icon, addIcon, dynamicIcon, staticIcon, yogaIcon)

import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled as S
import Html.Styled.Attributes as A
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Svg.Styled exposing (fromUnstyled, svg)
import Theme.Colors exposing (primary, primaryLight, white)


type alias Icon msg =
    Material.Icons.Types.Icon msg


yogaIcon : Float -> S.Html msg
yogaIcon size =
    S.img
        [ A.src "yoga.png"
        , A.css
            [ width (px size), margin (px 0) ]
        ]
        []


addIcon : Icon msg
addIcon =
    Filled.add_circle


dynamicIcon : Icon msg -> Float -> Color -> Color -> S.Html msg
dynamicIcon icon size color hoverColor =
    S.div [ A.css [ height (px size), maxWidth (px size), dynamicIconStyle color hoverColor ] ]
        [ svg
            []
            [ fromUnstyled <| icon (Basics.round size) Inherit ]
        ]


staticIcon : Icon msg -> Float -> Color -> S.Html msg
staticIcon icon size color =
    S.div [ A.css [ height (px size), maxWidth (px size), iconStyle color ] ]
        [ svg
            []
            [ fromUnstyled <| icon (Basics.round size) Inherit ]
        ]


iconStyle : Color -> Style
iconStyle colorValue =
    batch
        [ color colorValue
        , margin (px 0)
        ]


dynamicIconStyle : Color -> Color -> Style
dynamicIconStyle colorValue hoverColor =
    batch
        [ color colorValue
        , margin (px 0)
        , hover
            [ color hoverColor
            ]
        , transition
            [ Css.Transitions.color 300
            ]
        ]
