module Injuries exposing (..)

import Array
import Components.Card exposing (..)
import Components.Elements as C
import Components.Form exposing (anOption, controlInput, controlLabel, controlSelect, controlTextArea, defaultControlInputProps, defaultTextAreaProps, field, selectDefaultProps)
import Components.Modal exposing (modal, modalBody, modalCardTitle, modalHead)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Regions exposing (BodyRegion, bodyRegionToString, bodyRegions, fromRegion)
import Theme.Icons as I


type alias Injury =
    { description : String
    , region : BodyRegion
    , location : String
    }


type alias Model =
    { injuries : List Injury, addInjuryModalOpen : Bool }


init : List Injury -> Model
init injuriesList =
    { injuries = injuriesList, addInjuryModalOpen = False }


type Msg
    = OpenModal
    | CloseModal
    | UpdateChoice String


update : Model -> Msg -> Model
update model msg =
    case msg of
        OpenModal ->
            { model | addInjuryModalOpen = True }

        CloseModal ->
            { model | addInjuryModalOpen = False }

        UpdateChoice value ->
            model


view : Model -> Html Msg
view model =
    if model.addInjuryModalOpen then
        myModal

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


myModal : Html Msg
myModal =
    let
        locationInput =
            field []
                [ controlLabel [] [ text "location" ]
                , controlInput defaultControlInputProps [] [] []
                ]

        myTextArea =
            field []
                [ controlLabel [] [ text "description" ]
                , controlTextArea
                    defaultTextAreaProps
                    []
                    []
                    []
                ]

        regionsDropDown =
            let
                regionOptions =
                    bodyRegions
                        |> List.map (\br -> fromRegion br.region)
                        |> List.indexedMap Tuple.pair
                        |> List.map (\( value, key ) -> ( key, String.fromInt value ))
                        |> List.map anOption
            in
            controlSelect selectDefaultProps [] [ onInput UpdateChoice ] regionOptions

        sidesDropDown =
            let
                sideOptions =
                    [ "left", "right" ]
                        |> List.map (\r -> ( r, "" ))
                        |> List.map anOption
            in
            controlSelect selectDefaultProps [] [] sideOptions
    in
    modal
        []
        [ modalHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]
        , modalBody []
            [ locationInput
            , myTextArea
            , div [ A.css [ displayFlex ] ] [ regionsDropDown, sidesDropDown ]
            ]
        ]


getBodyRegion : Int -> Maybe BodyRegion
getBodyRegion index =
    Array.fromList bodyRegions |> Array.get index


displaySide : Int -> Bool
displaySide index =
    getBodyRegion index
        |> Maybe.map (\b -> b.side)
        |> Maybe.map (always True)
        |> Maybe.withDefault False
