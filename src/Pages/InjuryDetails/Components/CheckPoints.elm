module Pages.InjuryDetails.Components.CheckPoints exposing (..)

import Bulma.Styled.Elements exposing (..)
import Bulma.Styled.Modifiers as BM
import Components.Elements as C
import Components.Modal exposing (modalContent, simpleModal)
import Css exposing (displayFlex, maxWidth)
import Date as Date
import Domain.CheckPoint exposing (CheckPoint, Trend(..))
import Html.Styled exposing (Html, div, input, text)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import Json.Decode exposing (bool)
import List.FlatMap exposing (flatMap)
import Theme.Colors as ColorTheme
import Theme.Icons as I
import Util.Date as DateUtil


type alias Model =
    { comment : Maybe String }


init : Model
init =
    { comment = Nothing }


type Msg
    = OpenComment String
    | CloseComment


update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenComment comment ->
            { model | comment = Just comment }

        CloseComment ->
            { model | comment = Nothing }


view : Model -> List CheckPoint -> Html Msg
view model checkPoints =
    div []
        [ viewTable checkPoints
        , model.comment
            |> Maybe.map (\comment -> viewComment comment)
            |> Maybe.withDefault C.empty
        ]


viewComment : String -> Html Msg
viewComment comment =
    let
        header =
            C.empty
    in
    simpleModal True CloseComment header [ modalContent [] [ text comment ] ] header


viewTable : List CheckPoint -> Html Msg
viewTable checkPoints =
    table tableModifiers
        []
        [ tableHead [] []
        , myTableBody checkPoints
        , tableFoot [] []
        ]


myTableBody : List CheckPoint -> Html Msg
myTableBody checkPoints =
    let
        tableHeader =
            tableRow True
                []
                [ tableCell [] [ text "date" ]
                , tableCell [] [ text "pain" ]
                , tableCell [] [ text "trend" ]
                , tableCell [] [ C.simpleIcon "fa fa-comment" ColorTheme.white ]
                ]
    in
    tableBody []
        (tableHeader
            :: (checkPoints
                    |> List.map viewTableRow
               )
        )


viewTableRow : CheckPoint -> TableRow Msg
viewTableRow cp =
    tableRow
        False
        []
        [ tableCell [] [ text <| DateUtil.formatMMDY cp.date ]
        , tableCell [] [ text <| String.fromInt cp.painLevel ]
        , tableCell [] [ viewTrend cp.trend ]
        , tableCell []
            [ if String.isEmpty cp.comment then
                C.empty

              else
                C.simpleHoverIcon I.comment [ onClick (OpenComment cp.comment) ]
            ]
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
