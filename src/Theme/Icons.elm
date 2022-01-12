module Theme.Icons exposing (..)

import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled as S
import Html.Styled.Attributes as A
import Material.Icons.Types exposing (Coloring(..), Icon)
import Svg.Styled exposing (fromUnstyled, svg)


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


dynamicIcon : Icon msg -> Float -> Color -> Color -> S.Html msg
dynamicIcon icon size color hoverColor =
    S.div [ A.css [ height (px size), maxWidth (px size), dynamicIconStyle color hoverColor ] ]
        [ svg
            []
            [ fromUnstyled <| icon (Basics.round size) Inherit ]
        ]


staticIcon : Icon msg -> Float -> Color -> S.Html msg
staticIcon icon size colorValue =
    S.div [ A.css [ height (px size), maxWidth (px size), color colorValue, margin (px 0) ] ]
        [ svg
            []
            [ fromUnstyled <| icon (Basics.round size) Inherit ]
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


back : String
back =
    "fa fa-arrow-left"


add : String
add =
    "fa fa-plus"


save : String
save =
    "fa fa-save"


edit : String
edit =
    "fa fa-pencil"


calendar : String
calendar =
    "fa fa-calendar"


close : String
close =
    "fa fa-close"


region : String
region =
    "fa fa-compass"


caretDown : String
caretDown =
    "fa fa-caret-down"


filter : String
filter =
    "fa fa-filter"


comment : String
comment =
    "fa fa-comment"
