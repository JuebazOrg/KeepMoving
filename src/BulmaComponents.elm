module BulmaComponents exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Elements exposing (Icon, button, buttonModifiers, icon, tag, tagModifiers)
import Bulma.Styled.Modifiers exposing (..)
import Css exposing (fitContent, maxWidth)
import Html.Styled as S exposing (i)
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
    let
        buttonProps2 =
            { buttonModifiers
                | color = buttonProps.color
                , rounded = buttonProps.rounded
                , inverted = buttonProps.inverted
                , iconLeft = buttonProps.iconLeft
                , iconRight = buttonProps.iconRight
            } 
    in
    Bulma.Styled.Elements.button
        buttonProps2
        []
        messages


type alias ButtonProps msg =
    { outlined : Bool
    , inverted : Bool
    , rounded : Bool
    , color : Color
    , iconLeft : Maybe ( Size, List (S.Attribute msg), IconBody msg )
    , iconRight : Maybe ( Size, List (S.Attribute msg), IconBody msg )
    }


type alias IconBody msg =
    S.Html msg


defaultButtonProps : ButtonProps msg
defaultButtonProps =
    { outlined = False
    , inverted = False
    , rounded = True
    , color = Bulma.Styled.Modifiers.primary
    , iconLeft = Nothing
    , iconRight = Nothing
    }
