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
import Regions exposing (bodyRegionToString, regions)
import Theme.Icons as I


type alias Model =
    { injuries : List Injury, injuryModal : InjuryModal.Model, modalActive : Bool }


init : List Injury -> ( Model, Cmd Msg )
init injuriesList =
    ( { injuries = [], injuryModal = InjuryModal.init regions, modalActive = False }, httpCommand )


type Msg
    = OpenModal
    | InjuryModalMsg InjuryModal.Msg
    | SendHttpRequest
    | DataReceived (Result Http.Error (List Injury))


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

        DataReceived (Ok injuries) ->
            ( { model | injuries = injuries }, Cmd.none )

        DataReceived (Err injuries) ->
            -- todo: // on error
            ( model, Cmd.none )


httpCommand : Cmd Msg
httpCommand =
    Http.get
        { url = "http://localhost:3004/injuries"
        , expect = Http.expectJson DataReceived (Decode.list InjuryDecoder.decode)
        }


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries history" ], addInjuryBtn ]
        , div [ A.css [ displayFlex, flexDirection column, width (px 500) ] ] <|
            List.map
                (\i -> viewInjury i)
                model.injuries
        , if model.modalActive then
            map InjuryModalMsg <| InjuryModal.view model.injuryModal

          else
            C.empty
        ]


addInjuryBtn : Html Msg
addInjuryBtn =
    C.addButton [ onClick OpenModal ] [ text "Injury" ]


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
