module Pages.Injuries.Injuries exposing (..)

import Browser.Navigation as Nav
import Clients.InjuryClient as Client
import Compare exposing (Comparator)
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Components.Form exposing (controlCheckBox)
import Components.SlidingPanel as CS
import Css exposing (..)
import Date exposing (..)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onCheck, onClick)
import Navigation.Route as Route
import Pages.Injuries.Filters as Filters
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Icons as I
import Theme.Spacing as SP



-- todo : Modal se gere tout seul


type alias Model =
    { injuries : WebData (List Injury), filters : Filters.Model, navKey : Nav.Key }


type Order
    = LeastRecent
    | MostRecent


orders : List Order
orders =
    [ LeastRecent, MostRecent ]


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { injuries = RemoteData.NotAsked
      , filters = Filters.init
      , navKey = navKey
      }
    , getInjuries
    )


type Msg
    = FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | OpenDetail Injury
    | FiltersMsg Filters.Msg


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    let
        filters =
            model.filters
    in
    case msg of
        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )

        FiltersMsg subMsg ->
            ( { model | filters = Filters.update subMsg model.filters }, Cmd.none )

        OpenDetail injury ->
            ( model, Route.pushUrl (Route.Injury injury.id) model.navKey )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ]
            , C.addButton [ A.href (Route.routeToString Route.NewInjury) ] [ text "injury" ]
            ]
        , map FiltersMsg <| Filters.view model.filters
        , viewInjuriesOrError model
        ]


viewInjuriesOrError : Model -> Html Msg
viewInjuriesOrError model =
    case model.injuries of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injuries ->
            viewInjuries injuries model.filters

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


viewInjuries : List Injury -> Filters.Model -> Html Msg
viewInjuries injuries filterModel =
    div [ A.css [ displayFlex, flexDirection column ] ]
        (injuries
            |> Filters.filterInjuries filterModel.filters
            |> Filters.orderInjuries filterModel.order
            |> List.map
                (\i -> viewInjury i)
        )


viewInjury : Injury -> Html Msg
viewInjury injury =
    let
        startDate =
            injury.startDate
                |> Date.toIsoString
    in
    card
        [ onClick <| OpenDetail injury, A.css [ borderRadius SP.small, marginTop SP.medium, important (maxWidth (px 500)) ] ]
        [ cardHeader []
            [ cardTitle []
                [ C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                , if isActive injury then
                    C.warningTag [ A.css [ marginLeft SP.small ] ] [ text "active" ]

                  else
                    C.empty
                ]
            , cardIcon []
                [ C.icon
                    []
                    [ i [ A.class I.calendar ] []
                    ]
                , span [] [ text startDate ]
                , C.icon
                    [ A.css [ paddingLeft SP.small ] ]
                    [ i [ A.class I.edit ] []
                    ]
                ]
            ]
        , cardContent [] [ text <| injury.location ]
        ]
