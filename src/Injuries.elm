module Injuries exposing (..)

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
    ( { injuries = RemoteData.NotAsked, injuryModal = InjuryModal.init regions, modalActive = False }, httpCommand )


type Msg
    = OpenModal
    | InjuryModalMsg InjuryModal.Msg
    | SendHttpRequest
    | DataReceived (WebData (List Injury))


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

        SendHttpRequest ->
            ( model, httpCommand )

        DataReceived response ->
            ( { model | injuries = response }, Cmd.none )


httpCommand : Cmd Msg
httpCommand =
    Http.get
        { url = "http://localhost:3004/injuries"
        , expect =
            Decode.list InjuryDecoder.decode
                |> Http.expectJson (RemoteData.fromResult >> DataReceived)
        }


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
            div [] [ text <| buildErrorMessage httpError ]


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


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
