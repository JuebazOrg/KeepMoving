module Components.Calendar.DatePicker exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (on, targetValue)
import Html.Styled exposing (..)
import Json.Decode as Decode
type alias Model =
    String


type Msg
    = DateChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        DateChange newDate ->
            newDate


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    node "duet-date-picker"

onDatePickerChange : (String -> msg) -> Attribute msg
onDatePickerChange dateString =
    on "duetChange" (Decode.map dateString targetValue)

view : Model -> Html Msg
view model =
    datePicker [ A.attribute "id" "date-picker", onDatePickerChange DateChange ] []

