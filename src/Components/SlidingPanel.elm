module Components.SlidingPanel exposing (..)

import Components.Card as Card
import Components.Dropdown exposing (Msg)
import Components.Elements as C
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)


view : Bool -> msg -> List (Html msg)-> String -> Html msg
view isOpen msg content title =
    Card.card []
        [ Card.cardHeader []
            [ Card.cardTitle [] [ text title ]
            , C.dropDownButton [ onClick msg ] []
            ]
        , if isOpen then
            Card.cardContent [] content

          else
            C.empty
        ]
