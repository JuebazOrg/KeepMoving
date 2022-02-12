module  EventCalendar exposing (Model, view, update, Msg, init)

import Calendar exposing (CalendarDate, fromDate)
import CalendarColor as C
import Css exposing (..)
import Date as Date exposing (Date, fromCalendarDate)
import Event as E exposing (Event)
import EventExtra exposing (..)
import EventModal as EventModal
import Fake exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Maybe.Extra exposing (join)
import Mobile as Mobile
import Style as S exposing (EventStyle(..), spacing)
import Task
import Time exposing (Month(..), Weekday(..))
import Util exposing (..)


type alias EventModal =
    { event : Event, dayClicked : Date }


type alias Model =
    { currentCalendarDate : Date, today : Date, eventModal : Maybe EventModal }


init : ( Model, Cmd Msg )
init  =
    ( { currentCalendarDate = dateFromMonth Jul
      , today = dateFromMonth Jul
      , eventModal = Nothing
      }
    , now
    )


createCalendarFromDate : Date -> List (List CalendarDate)
createCalendarFromDate date =
    fromDate Nothing date


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
    | EventTrigger EventModal
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


view : List Event -> Model -> Html Msg
view events model =
    div [ A.css [ margin (px 10), S.fontStyle ] ]
        [ viewHeader model.currentCalendarDate
        , viewDayNames
        , viewMonth model events
        ]


viewHeader : Date -> Html Msg
viewHeader date =
    div [ A.css [ displayFlex, justifyContent center, alignItems center, marginBottom (spacing.xsmall) ] ]
        [ i [ onClick Back, A.class "fa fa-angle-left", A.css [ S.iconStyle ] ] []
        , div [ A.css [ displayFlex, margin2 (px 0) (spacing.small) ] ]
            [ h1 [] [ text <| monthToString (Date.month date) ]
            , h1 [ A.css [ marginLeft spacing.xsmall ] ] [ text <| String.fromInt (Date.year date) ]
            ]
        , i [ onClick Next, A.class "fa fa-angle-right", A.css [ S.iconStyle ] ] []
        ]


viewMonth : Model -> List Event -> Html Msg
viewMonth model events =
    div [] <|
        List.map
            (\week ->
                div [ A.css [ displayFlex ] ]
                    (week
                        |> List.map (\day -> viewDay day events model)
                    )
            )
            (createCalendarFromDate model.currentCalendarDate)


viewDayNames : Html Msg
viewDayNames =
    div [ A.css [ displayFlex, marginBottom spacing.xsmall ] ] <|
        List.map (\name -> div [ A.css [ flex (int 1) ] ] [ text <| daysOfWeekToString name ]) daysOfWeek


dayStyle : Style
dayStyle =
    batch
        [ flex (int 1)
        , displayFlex
        , height spacing.xxxlarge
        , flexDirection column
        , overflow hidden
        , Mobile.onMobile [ flex (int 1), displayFlex, height spacing.xxlarge, flexDirection column ]
        ]


viewDay : CalendarDate -> List Event -> Model -> Html Msg
viewDay day events model =
    div [ A.css [ dayStyle ] ] <|
        viewDayNumber day model.today
            :: viewEvents day events model


viewEvents : CalendarDate -> List Event -> Model -> List (Html Msg)
viewEvents day events model =
    let
        singleDayEvents =
            events |> List.filter (\e -> e.endDate == Nothing)

        multiDayEvents =
            events |> List.filter (\e -> e.endDate /= Nothing)
    in
    [ multiDayEvents
        |> List.filter (\e -> E.isEventBetweenDate day.date e)
        |> List.sortWith (E.eventComparator day.date)
        |> viewMultiDayEvents day.date model.eventModal
    , singleDayEvents
        |> List.filter (\i -> E.isEventOnDate day.date i)
        |> viewDayEvents model.eventModal
    ]


viewDayEvents : Maybe EventModal -> List Event -> Html Msg
viewDayEvents maybeEventClicked events =
    div []
        (events
            |> List.map
                (\e ->
                    div []
                        [ div [ onClick <| EventTrigger { event = e, dayClicked = e.startDate }
                        , A.css [ S.event S.DayEvent e.color ] ] [ span [ ] [ text e.name ] ]
                        , viewEventModal maybeEventClicked e e.startDate
                        ]
                )
        )


viewEventModal : Maybe EventModal -> Event -> Date -> Html Msg
viewEventModal maybeEvent event day =
    EventModal.view CloseModal
        (maybeEvent
            |> Maybe.map
                (\e ->
                    if e.event == event && e.dayClicked == day then
                        Just e.event

                    else
                        Nothing
                )
            |> join
        )


viewMultiDayEvents : Date -> Maybe EventModal -> List Event -> Html Msg
viewMultiDayEvents currentDate eventModal events =
    let
        viewMuliEventsStyled =
            events
                |> List.map
                    (\event ->
                        let
                            style =
                                retreiveMultiDayEventStyle event currentDate
                        in
                        div []
                            [ div [ onClick <| EventTrigger { event = event, dayClicked = currentDate }, A.css [ style ] ] [ text event.name ]
                            , viewEventModal eventModal event currentDate
                            ]
                    )
    in
    div [] viewMuliEventsStyled


viewDayNumber : CalendarDate -> Date -> Html Msg
viewDayNumber date today =
    if date.date == today then
        div [ A.css [ displayFlex, justifyContent center ] ] [ span [ A.css [ S.currentDay] ] [ text date.dayDisplay ] ]

    else
        div [ A.css [ displayFlex, justifyContent center ] ] [ text date.dayDisplay ]


retreiveMultiDayEventStyle : Event -> Date -> Style
retreiveMultiDayEventStyle event currentDate =
    if event.startDate == currentDate then
        S.event StartDate event.color

    else if E.isEndDate currentDate event then
        S.event EndDate event.color

    else
        S.event Middle event.color


empty : Html msg
empty =
    div [] []

