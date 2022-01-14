module Pages.EditInjury.View exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Calendar.DatePicker as DP
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (..)
import Components.SlidingPanel as SlidingPanel
import Css exposing (..)
import Date as Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (maybe)
import Navigation.Route as Route
import Pages.EditInjury.Update exposing (FormModel, Model, Msg(..), SubMsg(..))
import Theme.Mobile as M
import Theme.Spacing as SP
import Time exposing (Month(..))


view : Maybe FormModel -> Html Msg
view maybeForm =
    maybeForm
        |> Maybe.map (\f -> viewContent f)
        |> Maybe.withDefault C.empty


viewContent : FormModel -> Html Msg
viewContent model =
    div [ A.css [ height (pct 100), displayFlex, flexDirection column, justifyContent spaceBetween ] ]
        [ viewHeader
        , cardContent [ A.css [ flex (int 1), M.onMobile [ important <| padding (px 0) ] ] ]
            [ div [ A.css [ displayFlex, alignItems center, M.onMobile [ flexDirection column, alignItems flexStart ] ] ]
                [ span [ A.css [ margin SP.small ] ] [ map DropDownMsg (DD.viewDropDown model.regionDropdown) ]
                , span [ A.css [ margin SP.small ] ] [ map SideDropDownMsg (DD.viewDropDown model.sideDropDown) ]
                , span [ A.css [ margin SP.small ] ] [ map InjuryTypeDropDownMsg (DD.viewDropDown model.injuryTypeDropDown) ]
                ]
            , viewLocationInput
            , viewDescriptionInput
            , viewHowInput
            , span [ A.css [ displayFlex, M.onMobile [ flexDirection column ] ] ]
                [ viewStartDate model
                , viewEndDate model
                ]
            ]
        , cardFooter [ A.css [ padding (px 10), important displayFlex, important <| justifyContent flexEnd ] ] [ C.lightButton [ A.css [ marginRight (px 10) ] ] [ text "cancel" ], C.saveButton [] [ text "save" ] ] -- todo save
        ]
        |> map FormMsg


viewStartDate : FormModel -> Html SubMsg
viewStartDate model =
    field [] [ controlLabel [] [ text "Start date" ], map StartDateChange (DP.view model.startDate) ]


viewEndDate : FormModel -> Html SubMsg
viewEndDate model =
    field [ A.css [ marginLeft (px 10) ] ] [ controlLabel [] [ text "End date" ], map EndDateChange (DP.view model.endDate) ]


viewDescriptionInput : Html SubMsg
viewDescriptionInput =
    field []
        [ controlLabel [] [ text "description" ]
        , controlTextArea
            defaultTextAreaProps
            [ onInput UpdateDescription ]
            []
            []
        ]


viewHowInput : Html SubMsg
viewHowInput =
    field []
        [ controlLabel [] [ text "how it happen" ]
        , controlTextArea
            defaultTextAreaProps
            []
            []
            []
        ]


viewLocationInput : Html SubMsg
viewLocationInput =
    field [ A.css [ flex (int 3), marginRight (px 10) ] ]
        [ controlLabel [] [ text "location details" ]
        , controlInput defaultControlInputProps [ onInput UpdateLocation ] [] []
        ]


viewHeader : Html SubMsg
viewHeader =
    cardHeader [ A.css [ important <| alignItems center ] ] [ cardTitle [ A.css [ displayFlex, justifyContent spaceBetween ] ] [ C.h3Title [] [ text "New injury" ] ], C.closeButton [] [] ]



-- todo close modal


viewProgressBar : Html msg
viewProgressBar =
    ul [ A.class "steps" ]
        [ li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.class "is-active", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        , li [ A.class "steps-segment", A.css [ width (px 50) ] ] [ a [ A.class "steps-marker" ] [] ]
        ]
