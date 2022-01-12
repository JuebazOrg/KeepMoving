module Pages.InjuryDetails.InjuryDetail exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (cardHeader)
import Components.Elements as C
import Components.Modal as CM
import Css exposing (..)
import Date
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
import RemoteData as RemoteData exposing (RemoteData(..), WebData)
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


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuryReceived response ->
            ( { model | injury = response }, Cmd.none )

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


viewHeader : Injury -> Html Msg
viewHeader injury =
    div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
        [ C.backButton [ onClick GoBack ] []
        , C.h3Title [] [ text "Injury Details" ]
        , div [] []
        ]


viewContent : Injury -> CheckPointModal.Model -> Bool -> Html Msg
viewContent injury checkPointModal isModalOpen =
    div []
        [ viewHeader injury
        , viewInfo injury
        , viewCheckPointModal isModalOpen checkPointModal
        ]


viewCheckPoints : Injury -> Html Msg
viewCheckPoints injury =
    article [ A.class "tile is-child notification is-primar", A.css [ important <| padding SP.medium ] ]
        [ p [ A.class "subtitle" ] [ text "Checkpoints", C.addButton [ onClick OpenModal, A.css [ marginLeft SP.small ] ] [] ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ map CheckPointsMsg (CheckPoints.view injury.checkPoints)
            ]
        ]


viewInfo : Injury -> Html Msg
viewInfo injury =
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
                [ viewCheckPoints injury
                ]
            ]
        ]


viewTagInfo : Injury -> Html Msg
viewTagInfo injury =
    article [ A.class "tile is-child notification", A.css [ important <| padding SP.medium ] ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Region" ] ], C.mediumPrimaryTag [ text <| bodyRegionToString injury.bodyRegion ] ]
            , div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Location" ] ], C.mediumPrimaryTag [ text injury.location ] ]
            , div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Injury type" ] ], C.mediumPrimaryTag [ text <| injuryTypeToString injury.injuryType ] ]
            , div [ tagsContainerStyle ]
                [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Status" ] ]
                , C.mediumWarningTag
                    [ text <|
                        if Domain.Injury.isActive injury then
                            "Active"

                        else
                            "Healed"
                    ]
                ]
            ]
        ]


viewDescription : Injury -> Html Msg
viewDescription injury =
    article [ A.class "tile is-child notification is-primary" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ p [ A.class "subtitle" ] [ text "Description" ]
            , p [ A.class "content" ] [ text injury.description ]
            ]
        ]


viewHow : Injury -> Html Msg
viewHow injury =
    article [ A.class "tile is-child notification is-primary is-light" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ p [ A.class "subtitle" ] [ text "How it happened" ]
            , p [ A.class "content" ] [ text injury.how ]
            ]
        ]


viewDates : Injury -> Html Msg
viewDates injury =
    let
        endDateToString =
            Maybe.map Date.toIsoString >> Maybe.withDefault "-"
    in
    article [ A.class "tile is-child notification is-primary is-warning" ]
        [ p [ A.class "subtitle" ] [ text "When" ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ A.css [ displayFlex, flexDirection column, alignItems flexStart ] ]
                [ viewDateField (Date.toIsoString injury.startDate) "Start date"
                , viewDateField (endDateToString injury.endDate) "End date"
                ]
            ]
        ]


viewDateField : String -> String -> Html Msg
viewDateField date titleLabel =
    div [ A.css [ displayFlex, width (pct 100), justifyContent spaceBetween ] ]
        [ label [] [ text titleLabel ]
        , label [] [ text date ]
        ]


viewInjuryOrError : Model -> Html Msg
viewInjuryOrError model =
    case model.injury of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injury ->
            viewContent injury model.checkPointModal model.isModalOpen

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewCheckPointModal : Bool -> CheckPointModal.Model -> Html Msg
viewCheckPointModal isOpen model =
    let
        header =
            CM.modalCardHead [] [ CM.modalCardTitle [] [ text "Checkpoint" ], C.closeButton [ onClick CloseModal ] [] ]

        footer =
            CM.modalCardFoot [ A.css [ flexDirection rowReverse ] ] [ C.saveButton [ onClick SaveCheckpoint ] [] ]
    in
    CM.simpleModal isOpen header [ map CheckPointModalMsg <| CheckPointModal.view model ] footer



-- style --


tagsContainerStyle : Attribute msg
tagsContainerStyle =
    A.css [ displayFlex, marginBottom SP.medium, justifyContent spaceBetween ]
