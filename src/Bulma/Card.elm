module Bulma.Card exposing (..)

import Bulma.Styled.Components exposing (..)
import Html.Styled as S


card : List (S.Attribute msg) -> List (CardPartition msg) -> Card msg
card attributes cardPartition =
    Bulma.Styled.Components.card attributes cardPartition
