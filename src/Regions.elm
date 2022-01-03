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


type alias BodyRegion =
    { region : Region, side : Maybe Side }


bodyRegions : List BodyRegion
bodyRegions =
    [ { region = Leg, side = Just Left }
    , { region = Head, side = Nothing }
    ]


bodyRegionToString : BodyRegion -> String
bodyRegionToString bodyRegion =
    (Maybe.map
        fromSide
        bodyRegion.side
        |> withDefault ""
    )
        ++ " " ++ fromRegion bodyRegion.region


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
        Leg ->
            "Leg"

        Arm ->
            "arm"

        Neck ->
            "neck"

        Hands ->
            "hands"

        Wrist ->
            "wrist"

        UpperBack ->
            "upper back"

        MiddleBack ->
            "middle back"

        LowerBack ->
            "lower back"

        Feet ->
            "foot"

        Head ->
            "head"
