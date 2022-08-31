module Components.Elements exposing (..)

import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Components.BulmaElements exposing (..)
import Css exposing (Style, batch, borderRadius, color, height, hover, important, pct, px, width)
import Html.Styled as S
import Html.Styled.Attributes as A
import Theme.Colors as ColorTheme
import Theme.Icons as I


round : Style
round =
    batch
        [ important <| borderRadius (pct 50)
        ]


roundButton : Float -> List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
roundButton size attributes messages =
    let
        buttonP =
            { defaultButtonProps | color = BM.primary }
    in
    button buttonP (List.append attributes [ A.css [ round ] ]) messages


backButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
backButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.back ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }

        styled =
            List.append attributes [ A.css [ round ] ]
    in
    Components.BulmaElements.button buttonProps styled messages


addButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
addButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.add ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps attributes messages


saveButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
saveButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.save ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps attributes messages


deleteButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
deleteButton attributes messages =
    let
        myIcon =
            Just ( BM.small, [], icon [] [ S.i [ A.class I.delete ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.danger, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps attributes messages


dropDownButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
dropDownButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.caretDown ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps attributes messages


lightButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
lightButton attributes messages =
    let
        buttonProps =
            { defaultButtonProps | color = BM.primary }
    in
    Components.BulmaElements.button buttonProps attributes messages


closeButton : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
closeButton attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class I.close ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.primary, iconLeft = myIcon }

        styled =
            List.append attributes [ A.css [ round ] ]
    in
    Components.BulmaElements.button buttonProps styled messages


primaryTag : List (S.Html msg) -> S.Html msg
primaryTag messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.primary }
    in
    Components.BulmaElements.tag tagModifs [] messages


warningTag : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
warningTag attributes messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.warning }
    in
    Components.BulmaElements.tag tagModifs attributes messages


dangerTag : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
dangerTag attributes messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.danger }
    in
    Components.BulmaElements.tag tagModifs attributes messages


bigPrimaryTag : List (S.Html msg) -> S.Html msg
bigPrimaryTag messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.primary, size = BM.large }
    in
    Components.BulmaElements.tag tagModifs [] messages


mediumPrimaryTag : List (S.Html msg) -> S.Html msg
mediumPrimaryTag messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.primary, size = BM.medium }
    in
    Components.BulmaElements.tag tagModifs [] messages


mediumWarningTag : List (S.Html msg) -> S.Html msg
mediumWarningTag messages =
    let
        tagModifs =
            { defaultTagProps | color = BM.warning, size = BM.medium }
    in
    Components.BulmaElements.tag tagModifs [] messages


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


simpleIcon : String -> Css.Color -> BE.Icon msg
simpleIcon class colorValue =
    icon [ A.css [ color colorValue ] ] [ S.i [ A.class class ] [] ]


simpleHoverIcon : String -> List (S.Attribute msg) -> S.Html msg
simpleHoverIcon class messages =
    let
        style =
            List.append
                messages
                [ A.css
                    [ color ColorTheme.primary, hover [ color ColorTheme.primaryDark ] ]
                ]
    in
    icon style [ S.i [ A.class class ] [] ]


roundIconButton : String -> List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
roundIconButton className attributes messages =
    let
        myIcon =
            Just ( BM.standard, [], icon [] [ S.i [ A.class className ] [] ] )

        buttonProps =
            { defaultButtonProps | color = BM.light, iconLeft = myIcon }
    in
    Components.BulmaElements.button buttonProps (List.append attributes [ A.css [ round ] ]) messages


empty : S.Html msg
empty =
    S.text ""
