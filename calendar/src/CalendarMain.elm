module CalendarMain exposing (..)

import Browser
import Html.Styled exposing (..)
import EventCalendar as EventCalendar 

type alias Model = EventCalendar.Model

type Msg = CalendarMsg EventCalendar.Msg 

init : (Model, Cmd Msg)
init = 
    let 
        (model, cmd) = EventCalendar.init
    in 
    (model, Cmd.map CalendarMsg cmd)

view : Model -> Html Msg
view model = 
    map CalendarMsg <| EventCalendar.view model

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        CalendarMsg subMsg -> 
            let 
                (calendarModel,cmd) = EventCalendar.update subMsg model 
            in 
                (calendarModel, Cmd.map CalendarMsg cmd)

main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
