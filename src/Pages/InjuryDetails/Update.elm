module Pages.InjuryDetails.Update exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Cmd.Extra as Cmd
import Date as Date
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
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
    , editCheckPoints : Bool
    }


init : Nav.Key -> String -> ( Model, Cmd Msg )
init navKey id =
    ( { injury = RemoteData.Loading
      , navKey = navKey
      , checkPointModal = CheckPointModal.init
      , isModalOpen = False
      , checkPoints = CheckPoints.init
      , today = Nothing
      , editCheckPoints = False
      }
    , Cmd.batch [ getInjury id, now ]
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
    | EditCheckPoints


getInjury : String -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


now : Cmd Msg
now =
    Task.perform (Just >> SetDate) Date.today


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuryReceived response ->
            Cmd.pure { model | injury = response }

        InjuryUpdated response ->
            Cmd.pure { model | isModalOpen = False, injury = response }

        SetDate date ->
            Cmd.pure { model | today = date }

        GoBack ->
            ( model, Route.pushUrl Route.Injuries model.navKey )

        EditInjury injury ->
            ( model, Route.pushUrl (Route.EditInjury injury.id) model.navKey )

        OpenAddCheckPoint ->
            ( model, Cmd.none )

        CheckPointModalMsg subMsg ->
            Cmd.pure { model | checkPointModal = CheckPointModal.update subMsg model.checkPointModal }

        OpenModal ->
            Cmd.pure { model | isModalOpen = True }

        CloseModal ->
            Cmd.pure { model | isModalOpen = False }

        CheckPointsMsg subMsg ->
            Cmd.pure { model | checkPoints = CheckPoints.update subMsg model.checkPoints }

        SaveCheckpoint ->
            ( model
            , model.injury
                |> RemoteData.toMaybe
                |> Maybe.map (\i -> updateInjury model.checkPointModal i)
                |> Maybe.withDefault Cmd.none
            )

        EditCheckPoints ->
            ( { model | editCheckPoints = not model.editCheckPoints }, Cmd.none )


updateInjury : CheckPointModal.Model -> Injury -> Cmd Msg
updateInjury model injury =
    Client.updateInjury
        (getNewInjury model injury)
        (RemoteData.fromResult >> InjuryUpdated)


getNewInjury : CheckPointModal.Model -> Injury -> Injury
getNewInjury checkPointModal i =
    { i | checkPoints = CheckPointModal.getNewCheckPoint checkPointModal :: i.checkPoints }
