module Injuries exposing (..)

import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Elements exposing (button, buttonModifiers, icon)
import Bulma.Styled.Modifiers as BM
import Components exposing (box, iconButtonConstructor, secondaryButton, tag)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Theme.Colors exposing (..)
import Theme.Fonts as F
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
    List Injury


type Msg
    = Noop


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween, marginBottom (px 10) ] ] [ h2 [ A.css [ margin (px 0) ] ] [ text "Injuries" ], addInjuryBtn ]
        , div [] <|
            List.map
                (\i -> viewInjury i)
                model
        ]


addInjuryBtn : Html Msg
addInjuryBtn =
    let
        icon =
            Bulma.Styled.Elements.icon BM.standard [] [ i [ A.class "fa fa-reply" ] [] ]

        buttonModif =
            { buttonModifiers | color = BM.dark, iconLeft = Just ( BM.small, [], icon ) }
    in
    Bulma.Styled.Elements.button buttonModif [] [ text "injuries" ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    div [ A.css [ box white, maxWidth fitContent, F.primary, marginBottom (px 16) ] ]
        [ tag (fromRegion injury.region) BM.standard BM.primary
        , span
            [ A.css [ F.primary, color grey, alignSelf flexStart, paddingTop (px 5) ] ]
            [ text injury.location ]
        , p [] [ text injury.description ]
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
