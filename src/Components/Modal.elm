module Components.Modal exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Html.Styled as S
import Html.Styled.Attributes as A


modal :
    List (S.Attribute msg)
    -> List (BC.ModalCardPartition msg)
    -> BC.ModalPartition msg
modal attributes modalPartitions =
    BC.modalCard attributes modalPartitions


modalBody : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalBody attributes messages =
    BC.modalCardBody attributes messages


modalHead : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalHead attributes messages =
    BC.modalCardHead attributes messages


modalCardTitle : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
modalCardTitle attributes messages =
    BC.modalCardTitle attributes messages


modalCardFoot : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalCardFoot attributes messages =
    BC.modalCardFoot attributes messages
