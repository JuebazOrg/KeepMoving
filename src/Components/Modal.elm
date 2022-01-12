module Components.Modal exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Elements as BE
import Bulma.Styled.Modifiers as BM
import Css exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled as S
import Html.Styled.Attributes as A


modalCard :
    List (S.Attribute msg)
    -> List (BC.ModalCardPartition msg)
    -> BC.ModalPartition msg
modalCard attributes modalPartitions =
    BC.modalCard attributes modalPartitions


modalCardBody : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalCardBody attributes messages =
    BC.modalCardBody attributes messages


modalCardHead : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalCardHead attributes messages =
    BC.modalCardHead attributes messages


modalCardTitle : List (S.Attribute msg) -> List (S.Html msg) -> S.Html msg
modalCardTitle attributes messages =
    BC.modalCardTitle attributes messages


modalCardFoot : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalCardPartition msg
modalCardFoot attributes messages =
    BC.modalCardFoot attributes messages


modal :
    BC.IsModalOpen
    -> List (S.Attribute msg)
    -> List (BC.ModalPartition msg)
    -> BC.Modal msg
modal attributes partitions =
    BC.modal attributes partitions


modalContent : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalPartition msg
modalContent attributes messages =
    BC.modalContent attributes messages


modalBackground : List (S.Attribute msg) -> List (S.Html msg) -> BC.ModalPartition msg
modalBackground attributes messages =
    BC.modalBackground attributes messages


simpleModal : Bool -> msg-> BC.ModalCardPartition msg -> List (S.Html msg) -> BC.ModalCardPartition msg -> S.Html msg
simpleModal isOpen callback header content footer =
    modal isOpen
        []
        [ modalBackground [ onClick callback ] []
        , modalContent [ A.css [ displayFlex, important <| overflow visible ] ]
            [ modalCard [ A.css [ important <| overflow visible ] ]
                [ header
                , modalCardBody [ A.css [ important <| overflow visible ] ] content
                , footer
                ]
            ]
        ]
