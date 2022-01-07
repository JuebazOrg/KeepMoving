module Regions exposing (..)

import Maybe exposing (withDefault)


type Region
    = Leg
    | Arm
    | Neck
    | Hands
    | Wrist
    | UpperBack
    | MiddleBack
    | LowerBack
    | Feet
    | Head


type Side
    = Left
    | Right
    | Middle


type alias BodyRegion =
    { region : Region, side : Maybe Side }


regions : List Region
regions =
    [ Leg, Arm, Neck, Hands, Wrist, UpperBack, MiddleBack, LowerBack, Feet, Head ]


sides : List Side
sides =
    [ Left, Right, Middle ]


bodyRegionToString : BodyRegion -> String
bodyRegionToString bodyRegion =
    (Maybe.map
        fromSide
        bodyRegion.side
        |> withDefault ""
    )
        ++ " "
        ++ fromRegion bodyRegion.region


fromSide : Side -> String
fromSide side =
    case side of
        Right ->
            "Right"

        Left ->
            "Left"

        Middle ->
            "Middle"


fromRegion : Region -> String
fromRegion region =
    case region of
        Leg ->
            "Leg"

        Arm ->
            "Arm"

        Neck ->
            "Neck"

        Hands ->
            "Hands"

        Wrist ->
            "Wrist"

        UpperBack ->
            "Upper back"

        MiddleBack ->
            "Middle back"

        LowerBack ->
            "Lower back"

        Feet ->
            "Feet"

        Head ->
            "Head"
