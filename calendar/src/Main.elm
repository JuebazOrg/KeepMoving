module Main exposing (..)

import Browser
import Calendar as C exposing (CalendarDate)
import Color as C exposing (color8)
import Css exposing (..)
import Date as Date exposing (Date, fromCalendarDate)
import Event as E exposing (Event)
import EventModal as EventModal
import Fake exposing (..)
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
    { currentCalendarDate : Date, today : Date, events : List Event, eventModal : Maybe Event }


init : ( Model, Cmd Msg )
init =
    ( { currentCalendarDate = dateFromMonth Jul
      , today = dateFromMonth Jul
      , events = fakeEvents
      , eventModal = Nothing
      }
    , now
    )


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
    | EventTrigger Event
    | CloseModal


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

        EventTrigger event ->
            ( { model | eventModal = Just event }, Cmd.none )

        CloseModal ->
            ( { model | eventModal = Nothing }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ A.css [ margin (px 40), S.fontStyle ] ]
        [ viewHeader model.currentCalendarDate
        , viewDayNames
        , viewMonth model
        ]


viewHeader : Date -> Html Msg
viewHeader date =
    div [ A.css [ displayFlex, justifyContent center, alignItems center ] ]
        [ i [ onClick Back, A.class "fas fa-angle-left", A.css [ S.iconStyle ] ] []
        , div [ A.css [ displayFlex, margin2 (px 0) (Css.em 5) ] ]
            [ h1 [] [ text <| monthToString (Date.month date) ]
            , h1 [ A.css [ marginLeft (px 5) ] ] [ text <| String.fromInt (Date.year date) ]
            ]
        , i [ onClick Next, A.class "fas fa-angle-right", A.css [ S.iconStyle ] ] []
        ]


viewMonth : Model -> Html Msg
viewMonth model =
    div [] <|
        EventModal.view CloseModal model.eventModal
            :: List.map
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


viewDay : C.CalendarDate -> Date -> List Event -> Html Msg
viewDay day today events =
    div [ A.css [ flex (int 1), width (px 100), height (px 100), displayFlex, flexDirection column, overflow hidden ] ] <|
        viewDayNumber day today
            :: viewEvents day events


viewEvents : C.CalendarDate -> List Event -> List (Html Msg)
viewEvents day events =
    let 
        singleDayEvents = events |> List.filter (\e -> e.endDate == Nothing) 

        multiDayEvents = events |> List.filter (\e -> e.endDate /= Nothing)

    in 
    [ multiDayEvents
        |> List.filter (\e -> E.isEventBetweenDate day.date e)
        |> viewMultiDayEvents day.date
    , singleDayEvents
        |> List.filter (\i -> E.isEventOnDate day.date i)
        |> viewDayEvents
    ]


viewDayEvents : List Event -> Html Msg
viewDayEvents events =
    div []
        (events
            |> List.map
                (\event ->
                    div [ onClick <| EventTrigger (event), A.css [ S.event S.DayEvent event.color ] ] [ span [] [ text event.name ] ]
                )
        )


viewMultiDayEvents : Date -> List Event -> Html Msg
viewMultiDayEvents currentDate events =
    div []
        (events
            |> List.map
                (\event ->
                    if event.startDate == currentDate then
                        div [ onClick <| EventTrigger event, A.css [ S.event StartDate event.color ] ] [ text event.name ]

                    else if E.isEndDate currentDate event then
                        div [ onClick <| EventTrigger  event, A.css [ S.event EndDate event.color ] ] [ text event.name ]

                    else
                        div [ onClick <| EventTrigger event, A.css [ S.event Middle event.color ] ] [ text event.name ]
                )
        )


viewDayNumber : C.CalendarDate -> Date -> Html Msg
viewDayNumber date today =
    if date.date == today then
        div [ A.css [ displayFlex, justifyContent center ] ] [ span [ A.css [ backgroundColor C.blue, color C.white, padding (px 10), borderRadius (pct 50) ] ] [ text date.dayDisplay ] ]

    else
        div [ A.css [ displayFlex, justifyContent center ] ] [ text date.dayDisplay ]


empty : Html msg
empty =
    div [] []


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
