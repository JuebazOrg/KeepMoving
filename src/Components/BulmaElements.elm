module Components.BulmaElements exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Elements exposing (buttonModifiers)
import Bulma.Styled.Modifiers exposing (..)
import Css exposing (fitContent, maxWidth)
import Html.Styled as S
import Html.Styled.Attributes as A


tag : TagProps -> List (S.Html msg) -> S.Html msg
tag tagProps messages =
    Bulma.Styled.Elements.tag tagProps [ A.css [ maxWidth fitContent ] ] messages


button : ButtonProps msg -> List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
button buttonProps attributes messages =
    Bulma.Styled.Elements.button
        buttonProps
        attributes
        messages


type alias TagProps =
    Bulma.Styled.Elements.TagModifiers


defaultTagProps : TagProps
defaultTagProps =
    Bulma.Styled.Elements.tagModifiers


type alias ButtonProps msg =
    Bulma.Styled.Elements.ButtonModifiers msg


defaultButtonProps : ButtonProps ms
defaultButtonProps =
    buttonModifiers


type alias IconBody msg =
    S.Html msg
