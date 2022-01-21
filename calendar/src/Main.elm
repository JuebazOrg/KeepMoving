module Main exposing (..)

import Browser
import Calendar as C
import Css exposing (..)
import Date exposing (Date, fromCalendarDate)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Time exposing (Month(..), Weekday(..))



---- MODEL ----


july14th2020 =
    fromCalendarDate 2020 Jul 14


july14th2020calendar : List (List C.CalendarDate)
july14th2020calendar =
    C.fromDate Nothing july14th2020


type alias Calendar =
    List (List C.CalendarDate)


daysOfWeek : List Weekday
daysOfWeek =
    [ Sun, Mon, Tue, Wed, Thu, Fri, Sat ]


daysOfWeekToString : Weekday -> String
daysOfWeekToString day =
    case day of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"


monthToString : Month -> String
monthToString month =
    case month of
        Jan ->
            "januar"

        Feb ->
            "februar"

        Mar ->
            "marts"

        Apr ->
            "april"

        May ->
            "maj"

        Jun ->
            "juni"

        Jul ->
            "juli"

        Aug ->
            "august"

        Sep ->
            "september"

        Oct ->
            "oktober"

        Nov ->
            "november"

        Dec ->
            "december"


type alias Model =
    { calendar : Calendar, selectedMonth : Month }


init : ( Model, Cmd Msg )
init =
    ( { calendar = july14th2020calendar, selectedMonth = Jul }, Cmd.none )



---- UPDATE ----


type Msg
    = Next
    | Back


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        Back -> (model, Cmd.none)
        Next -> (model, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ A.css [ margin (px 40) ] ]
        [ viewHeader model.selectedMonth
        , viewDayNames
        , viewMonth model.calendar
        ]


viewHeader : Month -> Html Msg
viewHeader month =
    div [] [ button [onClick Back][text "<"] , text <| monthToString month, button [onClick Next][text ">"] ]


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
