module Pages.UserAccount exposing (..)

import Html.Styled exposing (..)
type alias Model = {name: String, email:String}

init: Model
init = {name = "Julie", email = "julie.bazerghi@outlook.com"}

view: Model -> Html msg
view model = 
    div [] [ text model.name, text model.email]