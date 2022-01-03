module Components.Form exposing (..)

import Bulma.Styled.Form as BF
import Html.Styled exposing (Attribute, Html, option, text)
import Html.Styled.Attributes as A


type alias ControlInputProps msg =
    BF.ControlInputModifiers msg


defaultControlInputProps : ControlInputProps msg
defaultControlInputProps =
    BF.controlInputModifiers


controlInput :
    BF.ControlInputModifiers msg
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> BF.Control msg
controlInput props controlAttributes inputAttributes messages =
    BF.controlInput props controlAttributes inputAttributes messages


field : List (Attribute msg) -> List (BF.Control msg) -> BF.Field msg
field attributes controls =
    BF.field attributes controls


controlLabel : List (Attribute msg) -> List (Html msg) -> BF.Control msg
controlLabel attributes messages =
    BF.controlLabel attributes messages


type alias ControlTextAreaProps =
    BF.ControlTextAreaModifiers


defaultTextAreaProps : ControlTextAreaProps
defaultTextAreaProps =
    BF.controlTextAreaModifiers


controlTextArea :
    BF.ControlTextAreaModifiers
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> BF.Control msg
controlTextArea controlAttributes inputAttributes messages =
    BF.controlTextArea controlAttributes inputAttributes messages


type alias ControlSelectModifiers msg =
    BF.ControlSelectModifiers msg


selectDefaultProps : ControlSelectModifiers msg
selectDefaultProps =
    BF.controlSelectModifiers


controlSelect :
    BF.ControlSelectModifiers msg
    -> List (Attribute msg)
    -> List (Attribute msg)
    -> List (BF.Option msg)
    -> BF.Control msg
controlSelect controlAttributes selectAttributes options =
    BF.controlSelect controlAttributes selectAttributes options


anOption : ( String, String ) -> Html msg
anOption ( key, val ) =
    option [ A.value val ]
        [ text key
        ]
