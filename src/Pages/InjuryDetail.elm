module Pages.InjuryDetail exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Components.Card exposing (cardHeader)
import Components.Elements as C
import Css exposing (..)
import Date
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import Id exposing (Id)
import Navigation.Route as Route
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Spacing as SP

type alias Model =
    { injury : WebData Injury, navKey : Nav.Key }


init : Nav.Key -> Id -> ( Model, Cmd Msg )
init navKey id =
    ( { injury = RemoteData.Loading, navKey = navKey }, getInjury id )


type Msg
    = InjuryReceived (WebData Injury)
    | GoBack


getInjury : Id -> Cmd Msg
getInjury id =
    Client.getInjury id (RemoteData.fromResult >> InjuryReceived)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InjuryReceived response ->
            ( { model | injury = response }, Cmd.none )

        GoBack ->
            ( model, Route.pushUrl Route.Injuries model.navKey )


view : Model -> Html Msg
view model =
    viewInjuryOrError model


viewHeader : Injury -> Html Msg
viewHeader injury =
    div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
        [ C.backButton [ onClick GoBack ] []
        , C.h3Title [] [ text "Injury Details" ]
        , div [] []
        ]


viewContent : Injury -> Html Msg
viewContent injury =
    div []
        [ viewHeader injury
        , viewInfo injury
        ]


viewInfo : Injury -> Html msg
viewInfo injury =
    div [ A.class "tile is-ancestor" ]
        [ div [ A.class "tile is-vertical is-4" ]
            [ div [ A.class "tile is-parent is-vertical" ]
                [ viewTagInfo injury
                , viewDescription injury
                , viewDates injury
                ]
            ]
        , div [ A.class "tile is-parent " ]
            [ viewHow injury
            ]
        ]


viewTagInfo : Injury -> Html msg
viewTagInfo injury =
    article [ A.class "tile is-child notification" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ A.css [ displayFlex, marginBottom SP.medium ] ] [ div [] [ C.h4Title [ A.css [ marginRight SP.small ] ] [ text "Region" ] ], C.bigPrimaryTag [ text <| bodyRegionToString injury.bodyRegion ] ]
            , div [ A.css [ displayFlex, marginBottom SP.medium ] ] [ div [] [ C.h4Title [ A.css [ marginRight SP.small ] ] [ text "Location" ] ], C.bigPrimaryTag [ text injury.location ] ]
            , div [ A.css [ displayFlex, marginBottom SP.medium ] ] [ div [] [ C.h4Title [ A.css [ marginRight SP.small ] ] [ text "Injury type" ] ], C.bigPrimaryTag [ text <| injuryTypeToString injury.injuryType ] ]
            , div [ A.css [ displayFlex, marginBottom SP.medium ] ]
                [ div [] [ C.h4Title [ A.css [ marginRight SP.small ] ] [ text "Status" ] ]
                , C.bigWarningTag
                    [ text <|
                        if Domain.Injury.isActive injury then
                            "Active"

                        else
                            "Healed"
                    ]
                ]
            ]
        ]


viewDescription : Injury -> Html msg
viewDescription injury =
    article [ A.class "tile is-child notification is-primary" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ p [ A.class "title" ] [ text "Description" ]
            , p [ A.class "content" ] [ text injury.description ]
            ]
        ]


viewHow : Injury -> Html msg
viewHow injury =
    article [ A.class "tile is-child notification is-primary is-light" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ p [ A.class "title" ] [ text "How it happened" ]
            , p [ A.class "content" ] [ text injury.how ]
            ]
        ]


viewDates : Injury -> Html msg
viewDates injury =
    let
        endDateToString =
            Maybe.map Date.toIsoString >> Maybe.withDefault "-"
    in
    article [ A.class "tile is-child notification is-primary is-warning" ]
        [ p [ A.class "title" ] [ text "When" ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ A.css [ displayFlex, flexDirection column, alignItems flexStart ] ]
                [ viewDateField (Date.toIsoString injury.startDate) "Start date"
                , viewDateField (endDateToString injury.endDate) "End date"
                ]
            ]
        ]


viewDateField : String -> String -> Html msg
viewDateField date label =
    div [ A.css [ displayFlex, width (pct 100), justifyContent spaceBetween ] ]
        [ C.h4Title [] [ text label ]
        , C.h4Title [] [ text date ]
        ]


viewInjuryOrError : Model -> Html Msg
viewInjuryOrError model =
    case model.injury of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injury ->
            viewContent injury

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]
