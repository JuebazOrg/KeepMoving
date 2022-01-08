module InjuryDetail exposing (..)

import Clients.InjuryClient as Client
import Css exposing (..)
import Html.Styled exposing (..)
import Injury exposing (..)
import RemoteData exposing (RemoteData(..), WebData)


type alias Model =
    { injury : WebData Injury }


init : Int -> ( Model, Cmd Msg )
init id =
    ( { injury = RemoteData.Loading }, getInjury id )


type Msg
    = InjuryReceived (WebData Injury)


getInjury : Int -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuryReceived response ->
            let
                log =
                    Debug.log "res" response
            in
            ( { model | injury = response }, Cmd.none )


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

        RemoteData.Success injuries ->
            div [] [ text injuries.location ]

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]
