module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Bulma.Styled.CDN exposing (..)
import Bulma.Styled.Components as BC
import Bulma.Styled.Modifiers as BM
import Components.Elements exposing (h4Title, roundButton)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Injuries as Injuries exposing (Msg, view)
import Injury as Injury
import InjuryDetail as InjuryDetail
import Navigation.Route as Route exposing (Route(..))
import SideBarNav exposing (Msg, viewSideNav)
import Theme.Colors exposing (..)
import Theme.Icons as I
import Url exposing (Url)


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | InjuriesPage Injuries.Model
    | InjuryPage InjuryDetail.Model


type Msg
    = InjuriesMsg Injuries.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Injuries ->
                    let
                        ( pageModel, pageCmds ) =
                            Injuries.init
                    in
                    ( InjuriesPage pageModel, Cmd.map InjuriesMsg pageCmds )

                Route.Injury id ->
                    let
                        pageModel =
                            InjuryDetail.init
                    in
                    ( InjuryPage pageModel, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( InjuriesMsg subMsg, InjuriesPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Injuries.update pageModel subMsg
            in
            ( { model | page = InjuriesPage updatedPageModel }
            , Cmd.map InjuriesMsg updatedCmd
            )

        ( _, _ ) ->
            ( model, Cmd.none )


myNavbarBurger : Html Msg
myNavbarBurger =
    BC.navbarBurger False
        []
        [ span [] []
        , span [] []
        , span [] []
        ]


viewNavBar : Bool -> Html Msg
viewNavBar isOpen =
    BC.fixedNavbar BM.top
        BC.navbarModifiers
        []
        [ BC.navbarBrand []
            myNavbarBurger
            [ BC.navbarItem False
                []
                [ h4Title [] [ text "Keep Moving" ]
                ]
            ]
        , BC.navbarMenu False
            []
            [ BC.navbarStart []
                [ BC.navbarItemLink False [] [ text "Home" ]
                , BC.navbarItemLink False [] [ text "Blog" ]
                , BC.navbarItemLink False [] [ text "Carrots" ]
                , BC.navbarItemLink False [] [ text "About" ]
                ]
            , BC.navbarEnd []
                [ BC.navbarItem False [] [ roundButton 45 [ text "JB" ] ] ]
            ]
        ]


view : Model -> Document Msg
view model =
    { title = "KeepMoving"
    , body =
        currentView model
            |> toUnstyled
            |> List.singleton
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        InjuriesPage pageModel ->
            div []
                [ stylesheet
                , fontAwesomeCDN
                , viewNavBar True
                , div
                    [ A.css [ padding (px 20) ] ]
                    [ map InjuriesMsg (Injuries.view pageModel)
                    ]
                ]

        InjuryPage injury ->
            InjuryDetail.view injury


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]


fontAwesomeCDN =
    node "link"
        [ A.rel "stylesheet"
        , A.href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
