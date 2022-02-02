module Components.DatePicker exposing (..)

import Date as Date exposing (Date)
import Html.Attributes exposing (type_)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (on, onInput)


type alias Model =
    Maybe Date


init : Model -> Model
init maybeInitialDate =
    maybeInitialDate


type Msg
    = DatePicked String


update : Msg -> Model -> Model
update msg model =
    case msg of
        DatePicked dateString ->
            case Date.fromIsoString dateString of
                Ok date_ ->
                    Just date_

                Err _ ->
                    Nothing


view : Model -> Html Msg
view model =
    case model of
        Nothing ->
            div []
                [ input [ A.class "input", A.type_ "date", onInput DatePicked ] []
                ]

        Just a ->
            div []
                [ input [ A.class "input", A.type_ "date", onInput DatePicked, A.value (Date.toIsoString a) ] []
                ]
