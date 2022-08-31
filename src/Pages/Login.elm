module Pages.Login exposing (..)
import Html.Styled exposing (..)
import Domain.Login exposing (LoginInfo) 

type alias Model = LoginInfo

init : (Model, Cmd msg)
init = ({name =  "", email = "", password = ""}, Cmd.none)

view : Model -> Html msg
view model = 
    div [][
        text "login"
    ]