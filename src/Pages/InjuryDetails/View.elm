module Pages.InjuryDetails.View exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (cardHeader)
import Components.Elements as C
import Components.Modal as CM
import Css exposing (..)
import Date as Date
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import Http
import Id exposing (Id)
import Navigation.Route as Route
import Pages.InjuryDetails.Components.AddCheckPoint as CheckPointModal
import Pages.InjuryDetails.Components.CheckPoints as CheckPoints
import Pages.InjuryDetails.Components.InjuryInfoCard exposing (..)
import Pages.InjuryDetails.Update exposing (Model, Msg(..))
import RemoteData as RemoteData exposing (RemoteData(..), WebData)
import Task
import Theme.Icons as I
import Theme.Mobile as M
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
                [ viewCheckPoints injury model.checkPoints
                ]
            ]
        ]


viewCheckPoints : Injury -> CheckPoints.Model -> Html Msg
viewCheckPoints injury checkPointsModel =
    article [ A.class "tile is-child notification is-primar", A.css [ important <| padding SP.medium ] ]
        [ p [ A.class "subtitle", A.css [ displayFlex, alignItems center, justifyContent center ] ] [ text "Checkpoints", C.addButton [ onClick OpenModal, A.css [ marginLeft SP.small ] ] [] ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ map CheckPointsMsg (CheckPoints.view checkPointsModel injury.checkPoints)
            ]
        ]


viewCheckPointModal : Bool -> CheckPointModal.Model -> Html Msg
viewCheckPointModal isOpen model =
    let
        header =
            CM.modalCardHead [] [ CM.modalCardTitle [] [ text "Checkpoint" ], C.closeButton [ onClick CloseModal ] [] ]

        footer =
            CM.modalCardFoot [ A.css [ flexDirection rowReverse ] ] [ C.saveButton [ onClick SaveCheckpoint ] [] ]
    in
    CM.simpleModal isOpen CloseModal header [ map CheckPointModalMsg <| CheckPointModal.view model ] footer
