module Tests exposing (..)

import Decoders.InjuryDecoder as InjuryDecoder
import Expect
import Json.Decode exposing (decodeValue)
import Json.Encode as Json
import Material.Icons exposing (description)
import Regions exposing (Region(..), Side(..))
import Test exposing (..)



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


all : Test
all =
    describe "InjuryDecoder"
        [ injuryDecoderTest
        ]


injuryDecoderTest : Test
injuryDecoderTest =
    test "decode an injury" <|
        \_ ->
            let
                injury =
                    { description = "description", location = "location", bodyRegion = { region = Leg, side = Just Left } }

                json =
                    Json.object
                        [ ( "description", Json.string injury.description )
                        , ( "location", Json.string injury.location )
                        , ( "bodyRegion"
                          , Json.object
                                [ ( "region", Json.string "Leg" )
                                , ( "side", Json.string "Left" )
                                ]
                          )
                        ]
            in
            decodeValue InjuryDecoder.decode json
                |> Expect.equal
                    (Ok { description = injury.description, location = injury.location, bodyRegion = { region = injury.bodyRegion.region, side = injury.bodyRegion.side } })
