module Pages.InjuryDetails.Update exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Date as Date
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Http
import Id exposing (Id)
import Navigation.Route as Route
import Pages.InjuryDetails.Components.AddCheckPoint as CheckPointModal
import Pages.InjuryDetails.Components.CheckPoints as CheckPoints
import Pages.InjuryDetails.Components.InjuryInfoCard exposing (..)
import RemoteData as RemoteData exposing (RemoteData(..), WebData)
import Task


type alias Model =
    { injury : WebData Injury
    , navKey : Nav.Key
    , checkPointModal : CheckPointModal.Model
    , isModalOpen : Bool
    , checkPoints : CheckPoints.Model
    , today : Maybe Date.Date
    }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { injury = RemoteData.Loading
      , navKey = navKey
      , checkPointModal = CheckPointModal.init
      , isModalOpen = False
      , checkPoints = CheckPoints.init
      , today = Nothing
      }
    , getInjury id
    )


type Msg
    = InjuryReceived (WebData Injury)
    | InjuryUpdated (WebData Injury)
    | GoBack
    | OpenAddCheckPoint
    | CheckPointModalMsg CheckPointModal.Msg
    | OpenModal
    | CloseModal
    | SaveCheckpoint
    | CheckPointsMsg CheckPoints.Msg
    | SetDate (Maybe Date.Date)
    | EditInjury Injury


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

        InjuryUpdated response ->
            ( { model | isModalOpen = False, injury = response }, now )

        SetDate date ->
            ( { model | today = date }, Cmd.none )

        GoBack ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        EditInjury injury ->
            ( model, Route.pushUrl (Route.EditInjury injury.id) model.navKey )

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
            ( model
            , cmd model.injury
                (\i ->
                    Client.updateInjury
                        (getNewInjury model.checkPointModal i)
                        (RemoteData.fromResult >> InjuryUpdated)
                )
            )


getNewInjury : CheckPointModal.Model -> Injury -> Injury
getNewInjury checkPointModal i =
    { i | checkPoints = CheckPointModal.getNewCheckPoint checkPointModal :: i.checkPoints }


cmd : WebData Injury -> (Injury -> Cmd msg) -> Cmd msg
cmd remoteData toCmd =
    remoteData
        |> RemoteData.map
            (\i -> toCmd i)
        |> RemoteData.withDefault Cmd.none
