module Pages.InjuryDetails.CheckPoints exposing (..)

import Bulma.Styled.Elements exposing (..)
import Components.Elements as C
import Date
import Domain.CheckPoint exposing (CheckPoint, Trend(..))
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes as A
import List.FlatMap exposing (flatMap)


view : List CheckPoint -> Html msg
view checkPoints =
    table tableModifiers
        []
        [ tableHead [] []
        , myTableBody checkPoints
        , tableFoot [] []
        ]


myTableBody : List CheckPoint -> Html msg
myTableBody checkPoints =
    let
        tableHeader =
            tableRow True
                []
                [ tableCell [] [ text "date" ]
                , tableCell [] [ text "painLevel" ]
                , tableCell [] [ text "resume" ]
                , tableCell [] [ text "trend" ]
                ]
    in
    tableBody []
        (tableHeader
            :: (checkPoints
                    |> List.map viewTableRow
               )
        )


viewTableRow : CheckPoint -> TableRow msg
viewTableRow cp =
    tableRow
        False
        []
        [ tableCell [] [ text <| Date.toIsoString cp.date ]
        , tableCell [] [ text <| String.fromInt cp.painLevel ]
        , tableCell [] [ text cp.comment ]
        , tableCell [] [ viewTrend cp.trend ]
        ]


viewTrend : Trend -> Html msg
viewTrend trend =
    case trend of
        Better ->
            C.primaryTag [ text "Better" ]

        Worst ->
            C.dangerTag [] [ text "Worst" ]

        Stable ->
            C.warningTag [] [ text "Stable" ]
