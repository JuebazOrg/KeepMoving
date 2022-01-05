module Components.Calendar.Calendar exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes as A


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    node "date-picker"


view : Html msg
view =
    datePicker [] []
