module Pages.InjuryDetails.InjuryDetail exposing (..)

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
import Pages.InjuryDetails.AddCheckPoint as CheckPointModal
import Pages.InjuryDetails.CheckPoints as CheckPoints
import Pages.InjuryDetails.DetailsComponents exposing (..)
import RemoteData as RemoteData exposing (RemoteData(..), WebData)
import Task
import Theme.Mobile as M
import Theme.Spacing as SP


type alias Model =
    { injury : WebData Injury
    , navKey : Nav.Key
    , checkPointModal : CheckPointModal.Model
    , isModalOpen : Bool
    , checkPoints : CheckPoints.Model
    }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { injury = RemoteData.Loading
      , navKey = navKey
      , checkPointModal = CheckPointModal.init
      , isModalOpen = False
      , checkPoints = CheckPoints.init
      }
    , getInjury id
    )


type Msg
    = InjuryReceived (WebData Injury)
    | GoBack
    | OpenAddCheckPoint
    | CheckPointModalMsg CheckPointModal.Msg
    | OpenModal
    | CloseModal
    | SaveCheckpoint
    | CheckPointsMsg CheckPoints.Msg
    | SetDate (Maybe Date.Date)


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


now : Cmd Msg
now =
    Task.perform (Just >> SetDate) Date.today


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuryReceived response ->
            ( { model | injury = response }, now )

        SetDate date -> 
            (model, Cmd.none)

        GoBack ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        OpenAddCheckPoint ->
            ( model, Cmd.none )

        CheckPointModalMsg subMsg ->
            ( { model | checkPointModal = CheckPointModal.update subMsg model.checkPointModal }, Cmd.none )

        OpenModal ->
            ( { model | isModalOpen = True }, Cmd.none )

        CloseModal ->
            ( { model | isModalOpen = False }, Cmd.none )

        CheckPointsMsg subMsg ->
            ( { model | checkPoints = CheckPoints.update subMsg model.checkPoints }, Cmd.none )

        SaveCheckpoint ->
            ( { model | isModalOpen = False }
            , case model.injury of
                RemoteData.Success injury ->
                    let
                        newInjury =
                            { injury | checkPoints = CheckPointModal.getNewCheckPoint model.checkPointModal :: injury.checkPoints }
                    in
                    Client.updateInjury newInjury (RemoteData.fromResult >> InjuryReceived)

                _ ->
                    Cmd.none
            )


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
            viewContent injury model.checkPointModal model.checkPoints model.isModalOpen

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewContent : Injury -> CheckPointModal.Model -> CheckPoints.Model -> Bool -> Html Msg
viewContent injury checkPointModal checkPointsModel isModalOpen =
    div []
        [ viewHeader injury
        , viewInfo injury checkPointsModel
        , viewCheckPointModal isModalOpen checkPointModal
        ]


viewHeader : Injury -> Html Msg
viewHeader injury =
    div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
        [ C.backButton [ onClick GoBack ] []
        , C.h3Title [] [ text "Injury Details" ]
        , div [] []
        ]


viewInfo : Injury -> CheckPoints.Model -> Html Msg
viewInfo injury checkPointsModel =
    div [ A.class "tile is-ancestor is-vertical" ]
        [ div [ A.class "tile" ]
            [ div [ A.class "tile is-parent is-vertical" ]
                [ viewTagInfo injury
                , viewDescription injury
                ]
            , div [ A.class "tile is-parent is-vertical" ]
                [ viewHow injury
                , viewDates injury
                ]
            ]
        , div [ A.class "tile" ]
            [ div [ A.class "tile is-parent" ]
                [ viewCheckPoints injury checkPointsModel
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
