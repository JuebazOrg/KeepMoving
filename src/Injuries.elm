module Injuries exposing (..)

import Components.Card exposing (..)
import Components.Elements as C
import Components.Form exposing (..)
import Css exposing (..)
import Css.Global exposing (body)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import InjuryModal exposing (viewModal)
import Regions exposing (BodyRegion, bodyRegionToString, bodyRegions, fromRegion)
import Theme.Icons as I


type alias Injury =
    { description : String
    , region : BodyRegion
    , location : String
    }


type alias Model =
    { injuries : List Injury, injuryModal : InjuryModal.Model, toggleModal : Bool }


init : List Injury -> Model
init injuriesList =
    { injuries = injuriesList, injuryModal = InjuryModal.init bodyRegions, toggleModal = False }


type Msg
    = OpenModal
    | InjuryModalMsg InjuryModal.Msg


update : Model -> Msg -> Model
update model msg =
    case msg of
        OpenModal ->
            { model | toggleModal = True }

        InjuryModalMsg subMsg ->
            { model | injuryModal = InjuryModal.update model.injuryModal subMsg }


view : Model -> Html Msg
view model =
    if model.toggleModal then
        map InjuryModalMsg <| InjuryModal.viewModal model.injuryModal

    else
        div []
            [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ], addInjuryBtn ]
            , div [ A.css [ displayFlex, flexDirection column, width (px 500) ] ] <|
                List.map
                    (\i -> viewInjury i)
                    model.injuries
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
