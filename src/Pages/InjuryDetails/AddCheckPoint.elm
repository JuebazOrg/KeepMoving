module Pages.InjuryDetails.AddCheckPoint exposing (..)

import Components.Calendar.DatePicker as DP
import Components.Dropdown as DD exposing (defaultProps)
import Components.Elements as C
import Components.Form as CF
import Components.Modal as CM
import Css exposing (..)
import Date
import Domain.CheckPoint exposing (CheckPoint, NewCheckPoint, Trend(..), levels, trendToString)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Id
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
    { trend = DD.init trendOptions "Trend" props
    , level = DD.init levelOptions "Pain level" props
    , date = DP.init
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
        [ CF.field [ A.css [ margin SP.small, displayFlex, justifyContent spaceBetween ] ] [ CF.controlLabel [] [ text "Trend" ], map TrendDropDownMsg <| DD.viewDropDown model.trend ]
        , CF.field [ A.css [ margin SP.small, displayFlex, justifyContent spaceBetween ] ] [ CF.controlLabel [] [ text "Pain Level" ], map LevelDropDownMsg <| DD.viewDropDown model.level ]
        , CF.field [ A.css [ margin SP.small, displayFlex, justifyContent spaceBetween ] ] [ CF.controlLabel [] [ text "Date" ], map DateChange <| DP.view model.date ]
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
    , date = Date.fromCalendarDate 2020 Jan 3
    , id = Id.noId
    }
