module Injuries exposing (..)

import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Components.Calendar.Calendar as Calendar
import Components.Card exposing (..)
import Components.Elements as C
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import InjuryModal exposing (viewModal)
import Regions exposing (BodyRegion, bodyRegionToString, fromRegion, regions)
import Theme.Icons as I


type alias Injury =
    { description : String
    , region : BodyRegion
    , location : String
    }


type alias Model =
    { injuries : List Injury, injuryModal : InjuryModal.Model, modalActive : Bool }


init : List Injury -> Model
init injuriesList =
    { injuries = injuriesList, injuryModal = InjuryModal.init regions, modalActive = False }


type Msg
    = OpenModal
    | InjuryModalMsg InjuryModal.Msg


update : Model -> Msg -> Model
update model msg =
    case msg of
        OpenModal ->
            { model | modalActive = True }

        InjuryModalMsg subMsg ->
            if subMsg == InjuryModal.CloseModal then
                { model | injuryModal = InjuryModal.update model.injuryModal subMsg, modalActive = False }

            else
                { model | injuryModal = InjuryModal.update model.injuryModal subMsg }


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ], addInjuryBtn ]
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
                , C.primaryTag [ text <| bodyRegionToString injury.region ]
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
