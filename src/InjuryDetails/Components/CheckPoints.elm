module InjuryDetails.Components.CheckPoints exposing (..)

import Bulma.Styled.Components exposing (easyModal, modalContent)
import Bulma.Styled.Elements exposing (TableRow, table, tableBody, tableCell, tableFoot, tableHead, tableModifiers, tableRow)
import Components.Elements as C
import Domain.CheckPoint exposing (CheckPoint, Trend(..))
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
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


view : Model -> List CheckPoint -> Bool -> Html Msg
view model checkPoints isEditMode =
    div []
        [ viewTable checkPoints isEditMode
        , model.comment
            |> Maybe.map (\comment -> viewComment comment)
            |> Maybe.withDefault (text "")
        ]


viewComment : String -> Html Msg
viewComment comment =
    easyModal True [] CloseComment [ modalContent [] [ text comment ] ]


viewTable : List CheckPoint -> Bool -> Html Msg
viewTable checkPoints isEditMode =
    table tableModifiers
        []
        [ tableHead [] []
        , myTableBody checkPoints isEditMode
        , tableFoot [] []
        ]


myTableBody : List CheckPoint -> Bool -> Html Msg
myTableBody checkPoints isEditMode =
    let
        tableHeader =
            tableRow True
                []
                [ tableCell [] [ text "date" ]
                , tableCell [] [ text "pain" ]
                , tableCell [] [ text "trend" ]
                , tableCell [] [ C.simpleIcon "fa fa-comment" ColorTheme.white ]
                , if isEditMode then
                    tableCell [ A.class "elem" ] [ text "delete" ]

                  else
                    C.empty
                ]
    in
    tableBody []
        (tableHeader
            :: (checkPoints
                    |> List.map (viewTableRow isEditMode)
               )
        )


viewTableRow : Bool -> CheckPoint -> TableRow Msg
viewTableRow isEditMode cp =
    tableRow
        False
        [ A.class "elem" ]
        [ tableCell [] [ text <| DateUtil.formatMMDY cp.date ]
        , tableCell [] [ text <| String.fromInt cp.painLevel ]
        , tableCell [] [ viewTrend cp.trend ]
        , tableCell []
            [ if String.isEmpty cp.comment then
                C.empty

              else
                C.simpleHoverIcon I.comment [ onClick (OpenComment cp.comment) ]
            ]
        , if isEditMode then
            tableCell [ A.class "elem" ] [ C.deleteButton [] [] ]

          else
            C.empty
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
