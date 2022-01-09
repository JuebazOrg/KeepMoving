module Pages.InjuryDetails.AddCheckPoint exposing (..)

import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form as CF
import Components.Modal as CM
import Css exposing (..)
import Domain.CheckPoint exposing (Trend(..), trendToString)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Theme.Spacing as SP


type alias Model =
    { trend : DD.Model Trend, level : DD.Model Int, date : DP.Model }


init : Model
init =
    { trend = DD.init trendOptions "Trend", level = DD.init levelOptions "Pain level", date = DP.init }


type Msg
    = TrendDropDownMsg (DD.Msg Trend)
    | LevelDropDownMsg (DD.Msg Int)
    | DateChange DP.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        TrendDropDownMsg sub ->
            { model | trend = DD.update model.trend sub }

        LevelDropDownMsg sub ->
            { model | level = DD.update model.level sub }

        DateChange sub ->
            { model | date = DP.update sub model.date }


view : Bool -> Model -> Html Msg
view bool model =
    CM.modal bool
        []
        [ CM.modalBackground [] []
        , CM.modalContent [ A.css [ displayFlex, important <| overflow visible ] ]
            [ CM.modalCard [ A.css [ important <| overflow visible ] ]
                [ CM.modalCardHead [] [ C.h4Title [] [ text "checkpoint" ] ]
                , CM.modalCardBody [ A.css [ important <| overflow visible ] ]
                    [ viewContent model
                    ]
                ]
            ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    div [ A.css [ displayFlex, flexWrap wrap ] ]
        [ span [ A.css [ margin SP.small ] ] [ map TrendDropDownMsg <| DD.viewDropDown model.trend ]
        , span [ A.css [ margin SP.small ] ] [ map LevelDropDownMsg <| DD.viewDropDown model.level ]
        , span [ A.css [ margin SP.small ] ] [ map DateChange <| DP.view model.date ]
        ]


trendOptions : List (DD.Option Trend)
trendOptions =
    [ Better, Worst, Stable ] |> List.map (\trend -> { label = trendToString trend, value = trend })


levelOptions : List (DD.Option Int)
levelOptions =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ] |> List.map (\i -> { label = String.fromInt i, value = i })
