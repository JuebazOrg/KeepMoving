module Pages.UserAccount exposing (..)

import Clients.UserClient as Client
import Domain.User exposing (User)
import Html.Styled exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Cmd.Extra as Cmd

type alias Model =
    WebData User


init : ( Model, Cmd Msg )
init =
    ( RemoteData.Loading, getUser )


type Msg
    = UserReceived (WebData User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        UserReceived webData ->
            Cmd.pure webData



getUser : Cmd Msg
getUser =
    Client.getUser (RemoteData.fromResult >> UserReceived)


view : Model -> Html Msg
view model =
    viewRemoteDataPage model


viewRemoteDataPage : Model -> Html Msg
viewRemoteDataPage model =
    case model of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success user ->
            div [] [ text user.name ]

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]
