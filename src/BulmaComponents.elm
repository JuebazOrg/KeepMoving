module BulmaComponents exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Elements exposing (Icon, button, buttonModifiers, tagModifiers)
import Bulma.Styled.Modifiers exposing (..)
import Css exposing (fitContent, maxWidth, ms)
import Html.Styled as S
import Html.Styled.Attributes as A


icon : Size -> List (S.Attribute msg) -> List (IconBody msg) -> Icon msg
icon size attributes =
    Bulma.Styled.Elements.icon size attributes


tag : List (S.Html msg) -> S.Html msg
tag messages =
    let
        tagModif =
            { tagModifiers | size = small }
    in
    Bulma.Styled.Elements.tag tagModif [ A.css [ maxWidth fitContent ] ] messages


button : ButtonProps msg -> List (S.Html msg) -> S.Html msg
button buttonProps messages =
    Bulma.Styled.Elements.button
        buttonProps
        []
        messages


type alias ButtonProps msg =
    Bulma.Styled.Elements.ButtonModifiers msg


defaultProps : ButtonProps ms
defaultProps =
    buttonModifiers


type alias IconBody msg =
    S.Html msg



-- defaultButtonProps : ButtonProps msg
-- defaultButtonProps =
--     { outlined = False
--     , inverted = False
--     , rounded = True
--     , color = Bulma.Styled.Modifiers.primary
--     , iconLeft = Nothing
--     , iconRight = Nothing
--     }
