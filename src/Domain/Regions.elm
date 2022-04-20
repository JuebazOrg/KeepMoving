module Domain.Regions exposing (..)

import Maybe exposing (withDefault)


type Region
    = Leg
    | Arm
    | Neck
    | Hand
    | Wrist
    | UpperBack
    | MiddleBack
    | LowerBack
    | Feet
    | Head
    | Other


type Side
    = Left
    | Right
    | Middle


type alias BodyRegion =
    { region : Region, side : Maybe Side }


regions : List Region
regions =
    [ Leg, Arm, Neck, Hand, Wrist, UpperBack, MiddleBack, LowerBack, Feet, Head, Other ]


sides : List Side
sides =
    [ Left, Right, Middle ]


bodyRegionToString : BodyRegion -> String
bodyRegionToString bodyRegion =
    (Maybe.map
        sideToString
        bodyRegion.side
        |> withDefault ""
    )
        ++ " "
        ++ fromRegion bodyRegion.region


sideToString : Side -> String
sideToString side =
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

        Hand ->
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

        Other ->
            "Other"
