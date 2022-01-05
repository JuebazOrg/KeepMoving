module Components.Calendar.DatePicker exposing (..)

import Date as Date
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (on, targetValue)
import Json.Decode as Decode


type alias Model =
    Maybe Date.Date


type Msg
    = DateChange String


init : Model
init =
    Nothing


update : Msg -> Model -> Model
update msg model =
    case msg of
        DateChange newDate ->
            let
                date =
                    Date.fromIsoString newDate
            in
            case date of
                Ok value ->
                    Just value

                Err _ ->
                    model


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    node "duet-date-picker"


onDatePickerChange : (String -> msg) -> Attribute msg
onDatePickerChange dateString =
    on "duetChange" (Decode.map dateString targetValue)


view : Model -> Html Msg
view model =
    datePicker [ A.attribute "id" "date-picker", onDatePickerChange DateChange ] []
