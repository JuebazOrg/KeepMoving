module Components.Calendar.DatePicker exposing (..)

import Date as Date exposing (Date)
import DatePicker
import Html.Attributes exposing (type_)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (on, onInput)
import Json.Decode as Decode


type alias Model =
    { date : Maybe Date }


init : Model
init =
    { date = Nothing }


type Msg
    = DatePicked String


update : Msg -> Model -> Model
update msg model =
    case msg of
        DatePicked dateString ->
            let
                date =
                    case Date.fromIsoString dateString of
                        Ok date_ ->
                            Just date_

                        Err _ ->
                            Nothing
            in
            { model | date = date }


view : Model -> Html Msg
view model =
    div []
        [ input [ A.class "input", A.type_ "date", onInput DatePicked ] []
        ]
