module Main exposing (..)

import Browser
import Calendar as C
import Css exposing (..)
import Date as Date exposing (Date, fromCalendarDate)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Time exposing (Month(..), Weekday(..))
import Util exposing (..)


---- MODEL ----





type alias Calendar =
    List (List C.CalendarDate)

type alias Model =
    { currentCalendarDate : Date }


init : ( Model, Cmd Msg )
init =
    ( { currentCalendarDate = dateFromMonth Jul }, Cmd.none )



createCalendarFromDate : Date -> List (List C.CalendarDate)
createCalendarFromDate date =
    C.fromDate Nothing date


daysOfWeek : List Weekday
daysOfWeek =
    [ Sun, Mon, Tue, Wed, Thu, Fri, Sat ]


dateFromMonth : Month -> Date
dateFromMonth month =
    fromCalendarDate 2020 month 1

---- UPDATE ----


type Msg
    = Next
    | Back


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Back ->
            let
                previousMonth =
                    Date.add Date.Months -1 model.currentCalendarDate
            in
            ( { model | currentCalendarDate = previousMonth }, Cmd.none )

        Next ->
            let
                nextMonth =
                    Date.add Date.Months 1 model.currentCalendarDate
            in
            ( { model | currentCalendarDate = nextMonth }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ A.css [ margin (px 40) ] ]
        [ viewHeader model.currentCalendarDate
        , viewDayNames
        , viewMonth <| createCalendarFromDate model.currentCalendarDate
        ]


viewHeader : Date -> Html Msg
viewHeader date =
    div [] [ button [ onClick Back ] [ text "<" ], text <| monthToString (Date.month date), text <| String.fromInt (Date.year date), button [ onClick Next ] [ text ">" ] ]


viewMonth : Calendar -> Html Msg
viewMonth calendar =
    div [] <|
        List.map
            (\week ->
                viewWeek week
            )
            calendar


viewWeek : List C.CalendarDate -> Html Msg
viewWeek week =
    div [ A.css [ displayFlex ] ] (week |> List.map (\day -> viewDay day))


viewDayNames : Html Msg
viewDayNames =
    div [ A.css [ displayFlex, marginBottom (px 10) ] ] <|
        List.map (\name -> div [ A.css [ flex (int 1) ] ] [ text <| daysOfWeekToString name ]) daysOfWeek


viewDay : C.CalendarDate -> Html Msg
viewDay day =
    div [ A.css [ flex (int 1), width (px 100), height (px 100) ] ] [ text day.dayDisplay ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
