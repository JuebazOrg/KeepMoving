module Components.Card exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Html.Styled as S
import Html.Styled.Attributes as A


card : List (S.Attribute msg) -> List (BC.CardPartition msg) -> BC.Card msg
card attributes cardPartition =
    BC.card attributes cardPartition


cardHeader : List (S.Attribute msg) -> List (S.Html msg) -> BC.CardPartition msg
cardHeader attributes messages =
    BC.cardHeader attributes messages


cardTitle : List (S.Attribute msg) -> List (S.Html msg) -> BC.CardHeaderItem msg
cardTitle attributes messages =
    BC.cardTitle attributes messages


cardIcon : List (S.Attribute msg) -> List (BE.Icon msg) -> BC.CardHeaderItem msg
cardIcon attributes iconMessages =
    BC.cardIcon attributes iconMessages


cardContent : List (S.Attribute msg) -> List (S.Html msg) -> BC.CardPartition msg
cardContent attributes messages =
    BC.cardContent attributes messages


cardFooter :
    List (S.Attribute msg)
    -> List (BC.CardFooterItem msg)
    -> BC.CardPartition msg
cardFooter attributes cardFooterItems =
    BC.cardFooter attributes cardFooterItems


cardFooterItemLink : List (S.Attribute msg) -> List (S.Html msg) -> BC.CardFooterItem msg
cardFooterItemLink attributes messages =
    BC.cardFooterItemLink attributes messages
