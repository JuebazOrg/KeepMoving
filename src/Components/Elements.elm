module Components.Elements exposing (..)

import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Components.BulmaElements exposing (..)
import Css exposing (borderRadius, height, px, width)
import Html.Styled as S
import Html.Styled.Attributes as A
import Theme.Icons as I


roundButton : Float -> List (S.Html msg) -> S.Html msg
roundButton size messages =
    let
        buttonP =
            { defaultButtonProps | rounded = True, color = BM.primary }
    in
    button buttonP [ A.css [ width (px size), height (px size), borderRadius (px size) ] ] messages


addButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
addButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.add ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps attributes messages


closeButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
closeButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.close ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon, rounded = True }
    in
    Components.BulmaElements.button buttonProps attributes messages


primaryTag : List (S.Html msg) -> S.Html msg
primaryTag messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.primary }
    in
    Components.BulmaElements.tag tagModifs messages


roundedTag : BE.TagModifiers -> List (S.Attribute msg) -> List (S.Html msg) -> BE.Tag msg
roundedTag modifs attributes messages =
    BE.roundedTag modifs attributes messages


h2Title : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
h2Title attributes messages =
    BE.title BE.h2 attributes messages


h3Title : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
h3Title attributes messages =
    BE.title BE.h3 attributes messages


h4Title : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
h4Title attributes messages =
    BE.title BE.h4 attributes messages


icon : List (S.Attribute msg) -> List (IconBody msg) -> BE.Icon msg
icon attributes iconBodyMsgs =
    BE.icon BM.standard attributes iconBodyMsgs
