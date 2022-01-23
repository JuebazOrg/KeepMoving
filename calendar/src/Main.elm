module Main exposing (..)

import Browser
import Calendar as C
import Color as C
import Css exposing (..)
import Date as Date exposing (Date, fromCalendarDate)
import Event as E exposing (DayEvent)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Task
import Time exposing (Month(..), Weekday(..))
import Util exposing (..)



---- MODEL ----


type alias Calendar =
    List (List C.CalendarDate)


type alias Model =
    { currentCalendarDate : Date, today : Date, events : List DayEvent }


init : ( Model, Cmd Msg )
init =
    ( { currentCalendarDate = dateFromMonth Jul, today = dateFromMonth Jul, events = E.fakeEvents }, now )


createCalendarFromDate : Date -> List (List C.CalendarDate)
createCalendarFromDate date =
    C.fromDate Nothing date


daysOfWeek : List Weekday
daysOfWeek =
    [ Sun, Mon, Tue, Wed, Thu, Fri, Sat ]


dateFromMonth : Month -> Date
dateFromMonth month =
    fromCalendarDate 2020 month 1


now : Cmd Msg
now =
    Task.perform (Just >> SetDate) Date.today



---- UPDATE ----


type Msg
    = Next
    | Back
    | SetDate (Maybe Date)


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

        SetDate maybeDate ->
            case maybeDate of
                Nothing ->
                    ( model, Cmd.none )

                Just date ->
                    ( { model | currentCalendarDate = date, today = date }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ A.css [ margin (px 40) ] ]
        [ viewHeader model.currentCalendarDate
        , viewDayNames
        , viewMonth model
        ]


viewHeader : Date -> Html Msg
viewHeader date =
    div [] [ button [ onClick Back ] [ text "<" ], text <| monthToString (Date.month date), text <| String.fromInt (Date.year date), button [ onClick Next ] [ text ">" ] ]


viewMonth : Model -> Html Msg
viewMonth model =
    div [] <|
        List.map
            (\week ->
                div [ A.css [ displayFlex ] ]
                    (week
                        |> List.map (\day -> viewDay day model.today model.events)
                    )
            )
            (createCalendarFromDate model.currentCalendarDate)


viewDayNames : Html Msg
viewDayNames =
    div [ A.css [ displayFlex, marginBottom (px 10) ] ] <|
        List.map (\name -> div [ A.css [ flex (int 1) ] ] [ text <| daysOfWeekToString name ]) daysOfWeek


viewDay : C.CalendarDate -> Date -> List DayEvent -> Html Msg
viewDay day today events =
    div [ A.css [ flex (int 1), width (px 100), height (px 100) ] ]
        [ viewDayNumber day today
        , events
            |> List.filter (\i -> E.isEventOnDate day.date i)
            |> viewDayEvents
        ]


empty : Html msg
empty =
    div [] []


viewDayEvents : List DayEvent -> Html Msg
viewDayEvents events =
    div [ A.css [ backgroundColor C.purple, color C.white, borderRadius (px 5) ] ] <| List.map (\event -> span [] [ text event.name ]) events


viewDayNumber : C.CalendarDate -> Date -> Html Msg
viewDayNumber date today =
    if date.date == today then
        div [] [ span [ A.css [ backgroundColor C.blue, color C.white, padding (px 10), borderRadius (pct 50) ] ] [ text date.dayDisplay ] ]

    else
        div [] [ text date.dayDisplay ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
