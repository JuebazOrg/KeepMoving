module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav

import Bulma.Styled.CDN exposing (..)
import Clients.InjuryClient as Client
import Css exposing (..)
import Domain.Injury exposing (Injury)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Id exposing (Id)
import Navigation.NavBar as NavBar exposing (viewNavBar)
import Navigation.Route as Route exposing (Route(..))
import Pages.AddInjury as AddInjury
import Pages.EditInjury as EditInjury
import Pages.Injuries.Injuries as Injuries exposing (Msg, view)
import Pages.InjuryDetails.Update as InjuryDetail
import Pages.InjuryDetails.View as InjuryDetailView
import Pages.UserAccount as UserAccount
import RemoteData exposing (WebData)
import Url exposing (Url)


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    , navBar : NavBar.Model
    }


type Page
    = NotFoundPage
    | InjuriesPage Injuries.Model
    | InjuryPage InjuryDetail.Model
    | NewInjuryPage AddInjury.Model
    | EditInjuryPage EditInjury.Model
    | AccountPage UserAccount.Model


type DomainMsg
    = InjuryReceived (WebData Injury)


type Msg
    = InjuriesMsg Injuries.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | InjuryDetailMsg InjuryDetail.Msg
    | NewInjuryPageMsg AddInjury.Msg
    | EditInjuryPageMsg EditInjury.Msg
    | NavBarMsg NavBar.Msg


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , navBar = NavBar.init navKey
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
                            Injuries.init model.navKey
                    in
                    ( InjuriesPage pageModel, Cmd.map InjuriesMsg pageCmds )

                Route.Injury id ->
                    let
                        ( pageModel, pageCmds ) =
                            InjuryDetail.init model.navKey id
                    in
                    ( InjuryPage pageModel, Cmd.map InjuryDetailMsg pageCmds )

                Route.NewInjury ->
                    ( NewInjuryPage <| AddInjury.init model.navKey, Cmd.none )

                Route.EditInjury id ->
                    let
                        ( pageModel, pageCmd ) =
                            EditInjury.init model.navKey id
                    in
                    ( EditInjuryPage <| pageModel
                    , Cmd.map EditInjuryPageMsg pageCmd
                    )
                Route.Account ->
                    (AccountPage <| UserAccount.init, Cmd.none)
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

        ( InjuryDetailMsg subMsg, InjuryPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    InjuryDetail.update subMsg pageModel
            in
            ( { model | page = InjuryPage updatedPageModel }
            , Cmd.map InjuryDetailMsg updatedCmd
            )

        ( NewInjuryPageMsg subMsg, NewInjuryPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    AddInjury.update pageModel subMsg
            in
            ( { model | page = NewInjuryPage updatedPageModel }
            , Cmd.map NewInjuryPageMsg updatedCmd
            )

        ( EditInjuryPageMsg subMsg, EditInjuryPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    EditInjury.update pageModel subMsg
            in
            ( { model | page = EditInjuryPage updatedPageModel }
            , Cmd.map EditInjuryPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Cmd.none
                      -- todo : wierd behavior
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( NavBarMsg sub, _ ) ->
            let
                (pageModel, pageCmd) = NavBar.update sub model.navBar
            in
        
            ( { model | navBar = pageModel }, Cmd.map NavBarMsg pageCmd )

        ( _, _ ) ->
            ( model, Cmd.none )


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
    let
        content =
            case model.page of
                NotFoundPage ->
                    notFoundView

                InjuriesPage pageModel ->
                    map InjuriesMsg (Injuries.view pageModel)

                InjuryPage pageModel ->
                    map InjuryDetailMsg (InjuryDetailView.view pageModel)

                NewInjuryPage pageModel ->
                    map NewInjuryPageMsg (AddInjury.view pageModel)

                EditInjuryPage pageModel ->
                    map EditInjuryPageMsg (EditInjury.view pageModel)
                AccountPage pageModel ->
                    (UserAccount.view pageModel)
    in
    div [ A.css [ height (pct 100) ] ]
        [ stylesheet
        , fontAwesomeCDN
        , map NavBarMsg (viewNavBar model.navBar)
        , div [ A.css [ padding (px 20) ] ] [ content ]
        ]


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
