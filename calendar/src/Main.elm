module Main exposing (..)

import Browser
import Calendar as C exposing (CalendarDate)
import Color as C
import Css exposing (..)
import Date as Date exposing (Date, fromCalendarDate)
import Event as E exposing (DayEvent, MultiDayEvent)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Style as S exposing (EventStyle(..))
import Task
import Time exposing (Month(..), Weekday(..))
import Util exposing (..)



---- MODEL ----


type alias Calendar =
    List (List C.CalendarDate)


type alias Model =
    { currentCalendarDate : Date, today : Date, events : List DayEvent, multiDayEvents : List MultiDayEvent }


init : ( Model, Cmd Msg )
init =
    ( { currentCalendarDate = dateFromMonth Jul, today = dateFromMonth Jul, events = E.fakeEvents, multiDayEvents = E.fakeMultiDayEvents }, now )


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

        -- , fontAwesomeCDN
        ]


viewHeader : Date -> Html Msg
viewHeader date =
    div [ A.css [ S.title, displayFlex, justifyContent center, alignItems center ] ]
        [ i [ onClick Back, A.class "fas fa-angle-left", A.css [hover [color C.grey]] ] []
        , div [A.css [displayFlex, margin2 (px 0) (Css.em 5)]]
            [ h1 [] [ text <| monthToString (Date.month date) ]
            , h1 [ A.css [ marginLeft (px 5) ] ] [ text <| String.fromInt (Date.year date) ]
            ]
        , i [ onClick Next, A.class "fas fa-angle-right",  A.css [hover [color C.grey] ]] []
        ]


viewMonth : Model -> Html Msg
viewMonth model =
    div [] <|
        List.map
            (\week ->
                div [ A.css [ displayFlex ] ]
                    (week
                        |> List.map (\day -> viewDay day model.today model.events model.multiDayEvents)
                    )
            )
            (createCalendarFromDate model.currentCalendarDate)


viewDayNames : Html Msg
viewDayNames =
    div [ A.css [ displayFlex, marginBottom (px 10) ] ] <|
        List.map (\name -> div [ A.css [ flex (int 1) ] ] [ text <| daysOfWeekToString name ]) daysOfWeek


viewDay : C.CalendarDate -> Date -> List DayEvent -> List MultiDayEvent -> Html Msg
viewDay day today events multiDayEvents =
    div [ A.css [ flex (int 1), width (px 100), height (px 100), displayFlex, flexDirection column, overflow hidden ] ]
        [ viewDayNumber day today
        , multiDayEvents
            |> List.filter (\event -> E.isEventBetweenDate day.date event)
            |> viewMultiDayEvents day
        , events
            |> List.filter (\i -> E.isEventOnDate day.date i)
            |> viewDayEvents
        ]


empty : Html msg
empty =
    div [] []


viewDayEvents : List DayEvent -> Html Msg
viewDayEvents events =
    div [] <| List.map (\event -> div [ A.css [ S.event S.DayEvent ] ] [ span [] [ text event.name ] ]) events


viewMultiDayEvents : CalendarDate -> List MultiDayEvent -> Html Msg
viewMultiDayEvents currentDay events =
    div [] <|
        List.map
            (\event ->
                if event.startDate == currentDay.date then
                    div [ A.css [ S.event StartDate ] ] [ text event.name ]

                else if event.endDate == currentDay.date then
                    div [ A.css [ S.event EndDate ] ] [ text event.name ]

                else
                    div [ A.css [ S.event Middle ] ] [ text event.name ]
            )
            events


viewDayNumber : C.CalendarDate -> Date -> Html Msg
viewDayNumber date today =
    if date.date == today then
        div [ A.css [ displayFlex, justifyContent center ] ] [ span [ A.css [ backgroundColor C.blue, color C.white, padding (px 10), borderRadius (pct 50) ] ] [ text date.dayDisplay ] ]

    else
        div [ A.css [ displayFlex, justifyContent center ] ] [ text date.dayDisplay ]



-- fontAwesomeCDN =
--     node "link"
--         [ A.rel "stylesheet"
--         , A.href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
--         ]
--         []
---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
