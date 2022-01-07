module Injuries exposing (..)

import Assemblers.InjuryDecoder as InjuryDecoder
import Clients.InjuryClient as Client
import Components.Card exposing (..)
import Components.Dropdown as DD
import Components.Elements as C
import Css exposing (..)
import Date
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (onClick)
import Http
import Injury exposing (..)
import InjuryModal exposing (viewModal)
import Json.Decode as Decode
import Material.Icons exposing (build)
import Regions exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Theme.Icons as I



-- todo : Modal se gere tout seul


type alias Model =
    { injuries : WebData (List Injury), injuryModal : InjuryModal.Model, filters : Filters }


type alias Filters =
    { region : DD.Model Region }


init : ( Model, Cmd Msg )
init =
    ( { injuries = RemoteData.NotAsked
      , injuryModal = InjuryModal.initClosed
      , filters =
            { region = DD.init regionDropdownOptions "Regions" }
      }
    , getInjuries
    )


type Msg
    = InjuryModalMsg InjuryModal.Msg
    | FetchInjuries
    | InjuriesReceived (WebData (List Injury))
    | RegionFilterMsg (DD.Msg Region)


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        InjuryModalMsg subMsg ->
            let
                ( injuryModalModel, cmd, outCmd ) =
                    InjuryModal.update model.injuryModal subMsg getInjuries
            in
            ( { model | injuryModal = injuryModalModel }, Cmd.batch [ outCmd, Cmd.map InjuryModalMsg cmd ] )

        FetchInjuries ->
            ( model, getInjuries )

        InjuriesReceived response ->
            ( { model | injuries = response }, Cmd.none )

        RegionFilterMsg subMsg ->
            ( { model | filters = { region = DD.update model.filters.region subMsg } }, Cmd.none )


getInjuries : Cmd Msg
getInjuries =
    Client.getInjuries (RemoteData.fromResult >> InjuriesReceived)


viewInjuriesOrError : Model -> Html Msg
viewInjuriesOrError model =
    case model.injuries of
        RemoteData.NotAsked ->
            text "not asked for yet"

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success injuries ->
            viewInjuries model.filters injuries

        RemoteData.Failure httpError ->
            div [] [ text <| Client.client.defaultErrorMessage httpError ]


view : Model -> Html Msg
view model =
    div []
        [ div [ A.css [ displayFlex, justifyContent spaceBetween ] ]
            [ C.h3Title [ A.css [ margin (px 0) ] ] [ text "Injuries" ]
            , map InjuryModalMsg (InjuryModal.view model.injuryModal)
            ]
        , viewFilters model.filters
        , viewInjuriesOrError model
        ]


viewInjuries : Filters -> List Injury -> Html Msg
viewInjuries filters injuries =
    div [ A.css [ displayFlex, flexDirection column ] ]
        (injuries
            |> filterInjuries filters
            |> List.map
                (\i -> viewInjury i)
        )


filterInjuries : Filters -> List Injury -> List Injury
filterInjuries filters injuries =
    let
        region =
            DD.getSelectedValue filters.region
    in
    case region of
        Just r ->
            injuries |> List.filter (\i -> i.bodyRegion.region == r)

        Nothing ->
            injuries


viewInjury : Injury -> Html Msg
viewInjury injury =
    card [ A.css [ borderRadius (px 5), margin (px 10), important (maxWidth (px 500)) ] ]
        [ cardHeader []
            [ cardTitle []
                [ span [ A.css [ paddingRight (px 7) ] ] [ text <| injury.location ]
                , C.primaryTag [ text <| bodyRegionToString injury.bodyRegion ]
                ]
            , cardIcon []
                [ C.icon
                    []
                    [ i [ A.class I.calendar ] []
                    ]
                , span [] [ text <| Date.toIsoString injury.startDate ]
                , C.icon
                    [ A.css [ paddingLeft (px 5) ] ]
                    [ i [ A.class I.edit ] []
                    ]
                ]
            ]
        , cardContent [] [ text injury.description ]
        ]


viewFilters : Filters -> Html Msg
viewFilters filters =
    section [] [ text "fitlers here", regionFilter filters ]


regionDropdownOptions : List (DD.Option Region)
regionDropdownOptions =
    regions
        |> List.map (\region -> { label = fromRegion region, value = DD.DropDownOption region })


regionFilter : Filters -> Html Msg
regionFilter filters =
    map RegionFilterMsg (DD.viewDropDown filters.region)
