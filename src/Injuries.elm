module Injuries exposing (..)

import Bulma.Styled.Modifiers as BM
import BulmaComponents exposing (button, defaultProps, icon, tag)
import Card exposing (..)
import Components exposing (box, iconButtonConstructor, secondaryButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Theme.Colors as C
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
        myIcon =
            Just ( BM.standard, [], icon BM.standard [] [ i [ A.class "fa fa-reply" ] [] ] )

        buttonProps =
            { defaultProps | color = BM.primary, inverted = True, iconLeft = myIcon }
    in
    BulmaComponents.button buttonProps [ text "injuries" ]



-- viewInjury : Injury -> Html Msg
-- viewInjury injury =
--     div [ A.css [ box C.white, maxWidth fitContent, marginBottom (px 16) ] ]
--         [ tag [ text (fromRegion injury.region) ]
--         , span
--             [ A.css [ color C.grey, alignSelf flexStart, paddingTop (px 5) ] ]
--             [ text injury.location ]
--         , p [] [ text injury.description ]
--         ]


viewInjury : Injury -> Html Msg
viewInjury injury =
    card [ A.css [ borderRadius (px 5), margin (px 20) ] ] [ tag [ text "injury" ] ]


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
