module Components.SlidingPanel exposing (..)

import Components.Card as Card
import Components.Dropdown exposing (Msg)
import Components.Elements as C
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Theme.Icons as I


view : Bool -> msg -> List (Html msg) -> String -> Html msg
view isOpen msg content title =
    Card.staticCard []
        [ Card.cardHeader [ A.css [ displayFlex ] ]
            [ Card.cardTitle [] [ text title ]
            , button [ A.class "card-header-icon", onClick msg ]
                [ C.icon [] [ i [ A.class I.caretDown ] [] ]
                ]
            ]
        , if isOpen then
            Card.cardContent [] content

          else
            C.empty
        ]
