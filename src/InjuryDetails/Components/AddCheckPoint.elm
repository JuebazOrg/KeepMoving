module InjuryDetails.Components.AddCheckPoint exposing (Model, Msg, getNewCheckPoint, init, update, view)

import Bulma.Styled.Form as BF
import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD exposing (defaultProps)
import Css exposing (..)
import Date
import Domain.CheckPoint exposing (CheckPoint, Trend(..), levels, trendToString)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Theme.Spacing as SP
import Time exposing (Month(..))


type alias Model =
    { trend : DD.Model Trend, level : DD.Model Int, date : DP.Model }


init : Model
init =
    let
        props =
            { defaultProps | hasDefaulTitleOption = False }
    in
    { trend = DD.init trendOptions Nothing "Trend" props
    , level = DD.init levelOptions Nothing "Pain level" props
    , date = DP.init Nothing
    }


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


view : Model -> Html Msg
view model =
    div [ A.css [ displayFlex, flexDirection column ] ]
        [ BF.field [ fieldAttribute ] [ BF.controlLabel [] [ text "Trend" ], map TrendDropDownMsg <| DD.viewDropDown model.trend ]
        , BF.field [ fieldAttribute ] [ BF.controlLabel [] [ text "Pain Level" ], map LevelDropDownMsg <| DD.viewDropDown model.level ]
        , BF.field [ fieldAttribute ] [ BF.controlLabel [] [ text "Date" ], map DateChange <| DP.view model.date ]
        ]


trendOptions : List (DD.Option Trend)
trendOptions =
    [ Better, Worst, Stable ] |> List.map (\trend -> { label = trendToString trend, value = trend })


levelOptions : List (DD.Option Int)
levelOptions =
    levels |> List.map (\i -> { label = String.fromInt i, value = i })


getNewCheckPoint : Model -> CheckPoint
getNewCheckPoint model =
    { comment = ""
    , trend = Maybe.withDefault Stable <| DD.getSelectedValue model.trend
    , painLevel = Maybe.withDefault 5 <| DD.getSelectedValue model.level
    , date = Maybe.withDefault (Date.fromCalendarDate 2 Jan 2020) model.date
    , id = "todo"
    }


fieldAttribute : Attribute msg
fieldAttribute =
    A.css [ margin SP.small, displayFlex, justifyContent spaceBetween ]
