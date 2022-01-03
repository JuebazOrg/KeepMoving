module Injuries exposing (..)

import Components.Card exposing (..)
import Components.Components as C
import Components.Modal exposing (modal, modalBody, modalCardTitle, modalHead)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Theme.Icons as I


type alias Injury =
    { description : String
    , region : Region
    , location : String
    }


type Region
    = Leg Side
    | Arm Side
    | Neck
    | Hands Side
    | Wrist Side
    | UpperBack
    | MiddleBack
    | LowerBack
    | Feet Side


type Side
    = Right
    | Left


type alias Model =
    { injuries : List Injury, addInjuryModalOpen : Bool }


init : List Injury -> Model
init injuriesList =
    { injuries = injuriesList, addInjuryModalOpen = False }


type Msg
    = OpenModal
    | CloseModal


update : Model -> Msg -> Model
update model msg =
    case msg of
        OpenModal ->
            { model | addInjuryModalOpen = True }

        CloseModal ->
            { model | addInjuryModalOpen = False }


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
                , C.primaryTag [ text <| fromRegion injury.region ]
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
    modal
        []
        [ modalHead [] [ modalCardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ text "New injury" ], C.closeButton [ onClick CloseModal ] [] ]
        , modalBody []
            [ text "Anything can go here!"
            ]
        ]


fromSide : Side -> String
fromSide side =
    case side of
        Right ->
            "right"

        Left ->
            "left"


fromRegion : Region -> String
fromRegion region =
    case region of
        Leg side ->
            fromSide side
                ++ " "
                ++ "Leg"

        Arm side ->
            fromSide side ++ " " ++ "leg"

        Neck ->
            "neck"

        Hands side ->
            fromSide side ++ " " ++ "hands"

        Wrist side ->
            fromSide side ++ " " ++ " " ++ "wrist"

        UpperBack ->
            "upper back"

        MiddleBack ->
            "middle back"

        LowerBack ->
            "lower back"

        Feet side ->
            fromSide side ++ " " ++ "foot"
