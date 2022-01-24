module EventExtra exposing (..)

import Html.Styled.Events exposing (on)
import Json.Decode exposing (..)


type alias MouseMoveData =
    { offsetX : Int
    , offsetY : Int
    , offsetHeight : Float
    , offsetWidth : Float
    }


decoder : Decoder MouseMoveData
decoder =
    map4 MouseMoveData
        (at [ "offsetX" ] int)
        (at [ "offsetY" ] int)
        (at [ "target", "offsetHeight" ] float)
        (at [ "target", "offsetWidth" ] float)
