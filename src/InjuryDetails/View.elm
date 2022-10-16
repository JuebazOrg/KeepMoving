module InjuryDetails.View exposing (..)

import Bulma.Styled.Components as BM
import Clients.InjuryClient as Client
import Components.Elements as C
import Css exposing (..)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import InjuryDetails.Components.AddCheckPoint as CheckPointModal
import InjuryDetails.Components.CheckPoints as CheckPoints
import InjuryDetails.Components.InjuryInfoCard exposing (..)
import InjuryDetails.Update exposing (Model, Msg(..))
import RemoteData as RemoteData exposing (RemoteData(..))
import Theme.Icons as I
import Theme.Spacing as SP


view : Model -> Html Msg
view model =
    viewInjuryOrError model


viewInjuryOrError : Model -> Html Msg
viewInjuryOrError model =
    case model.injury of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injury ->
            viewContent injury model

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewContent : Injury -> Model -> Html Msg
viewContent injury model =
    div []
        [ viewHeader injury
        , viewInfo injury model
        , viewCheckPointModal model.isModalOpen model.checkPointModal
        ]


viewHeader : Injury -> Html Msg
viewHeader injury =
    div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
        [ C.backButton [ onClick GoBack ] []
        , C.h3Title [] [ text "Injury Details" ]
        , div [] [ C.roundIconButton I.edit [ onClick <| EditInjury injury ] [] ]
        ]


viewInfo : Injury -> Model -> Html Msg
viewInfo injury model =
    div [ A.class "tile is-ancestor is-vertical" ]
        [ div [ A.class "tile" ]
            [ div [ A.class "tile is-parent is-vertical" ]
                [ viewTagInfo injury
                , viewDescription injury
                ]
            , div [ A.class "tile is-parent is-vertical" ]
                [ viewHow injury
                , viewDates injury model.today
                ]
            ]
        , div [ A.class "tile" ]
            [ div [ A.class "tile is-parent" ]
                [ viewCheckPoints injury model.checkPoints model.editCheckPoints
                ]
            ]
        ]


viewCheckPointsHeader : Html Msg
viewCheckPointsHeader =
    BM.modalCardTitle [ A.class "subtitle", A.css [ displayFlex, justifyContent flexEnd, alignItems center ] ]
        [ span [ A.css [ flex (int 1) ] ] [ text "Checkpoints" ], C.addButton [ onClick OpenModal, A.css [ marginRight SP.medium ] ] [], C.simpleHoverIcon I.edit [ onClick EditCheckPoints ] ]


viewCheckPoints : Injury -> CheckPoints.Model -> Bool -> Html Msg
viewCheckPoints injury checkPointsModel editCheckPoints =
    article [ A.class "tile is-child notification is-primar", A.css [ important <| padding SP.medium ] ]
        [ viewCheckPointsHeader
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ map CheckPointsMsg (CheckPoints.view checkPointsModel injury.checkPoints editCheckPoints)
            ]
        ]


viewCheckPointModal : Bool -> CheckPointModal.Model -> Html Msg
viewCheckPointModal isOpen model =
    let
        header =
            BM.modalCardHead [] [ BM.modalCardTitle [] [ text "Checkpoint" ], C.closeButton [ onClick CloseModal ] [] ]

        footer =
            BM.modalCardFoot [ A.css [ flexDirection rowReverse ] ] [ C.saveButton [ onClick SaveCheckpoint ] [] ]
    in
    C.simpleModal isOpen CloseModal header [ map CheckPointModalMsg <| CheckPointModal.view model ] footer
