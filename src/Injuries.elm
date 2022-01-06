module Injuries exposing (..)

import Clients.InjuryClient as Client
import Components.Card exposing (..)
import Components.Elements as C
import Css exposing (..)
import Decoders.InjuryDecoder as InjuryDecoder
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Http
import Injury exposing (..)
import InjuryModal exposing (viewModal)
import Json.Decode as Decode
import Material.Icons exposing (build)
import Regions exposing (bodyRegionToString, regions)
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Icons as I



-- todo : Modal se gere tout seul


type alias Model =
    { injuries : WebData (List Injury), injuryModal : InjuryModal.Model, modalActive : Bool }


init : List Injury -> ( Model, Cmd Msg )
init injuriesList =
    ( { injuries = RemoteData.NotAsked, injuryModal = InjuryModal.init regions, modalActive = False }, getInjuries )


type Msg
    = OpenModal
    | InjuryModalMsg InjuryModal.Msg
    | FetchInjuries
    | InjuriesReceived (WebData (List Injury))


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        OpenModal ->
            ( { model | modalActive = True }, Cmd.none )

        InjuryModalMsg subMsg ->
            if subMsg == InjuryModal.CloseModal then
                ( { model | injuryModal = InjuryModal.update model.injuryModal subMsg, modalActive = False }, Cmd.none )

            else
                ( { model | injuryModal = InjuryModal.update model.injuryModal subMsg }, Cmd.none )

        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


viewInjuriesOrError : Model -> Html Msg
viewInjuriesOrError model =
    case model.injuries of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injuries ->
            viewInjuries injuries

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries history" ], addInjuryBtn ]
        , viewInjuriesOrError model
        , if model.modalActive then
            map InjuryModalMsg <| InjuryModal.view model.injuryModal

          else
            C.empty
        ]


addInjuryBtn : Html Msg
addInjuryBtn =
    C.addButton [ onClick OpenModal ] [ text "Injury" ]


viewInjuries : List Injury -> Html Msg
viewInjuries injuries =
    div [ A.css [ displayFlex, flexDirection column, width (px 500) ] ] <|
        List.map
            (\i -> viewInjury i)
            injuries


viewInjury : Injury -> Html Msg
viewInjury injury =
    card [ A.css [ borderRadius (px 5), margin (px 20) ] ]
        [ cardHeader []
            [ cardTitle []
                [ span [ A.css [ paddingRight (px 7) ] ] [ text <| injury.location ]
                , C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                ]
            , cardIcon []
                [ C.icon
                    []
                    [ i [ A.class I.calendar ] []
                    ]
                , span [] [ text "30 Jan 2020" ]
                , C.icon
                    [ A.css [ paddingLeft (px 5) ] ]
                    [ i [ A.class I.edit ] []
                    ]
                ]
            ]
        , cardContent [] [ text injury.description ]
        ]
