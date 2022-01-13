module Pages.InjuryDetails.Components.InjuryInfoCard exposing (..)

import Components.Elements as C
import Css exposing (..)
import Date exposing (Date, Unit(..), diff)
import Domain.Injury exposing (Injury, injuryTypeToString)
import Domain.Regions exposing (bodyRegionToString)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import Theme.Icons as I
import Theme.Spacing as SP
import Util.Date exposing (formatMMMMDY)


viewTagInfo : Injury -> Html msg
viewTagInfo injury =
    article [ A.class "tile is-child notification", A.css [ important <| padding SP.medium ] ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Region" ] ], C.mediumPrimaryTag [ text <| bodyRegionToString injury.bodyRegion ] ]
            , div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Location" ] ], C.mediumPrimaryTag [ text injury.location ] ]
            , div [ tagsContainerStyle ] [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Injury type" ] ], C.mediumPrimaryTag [ text <| injuryTypeToString injury.injuryType ] ]
            , div [ tagsContainerStyle ]
                [ div [] [ label [ A.css [ marginRight SP.small ] ] [ text "Status" ] ]
                , C.mediumWarningTag
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
            [ p [ A.class "subtitle" ] [ text "Description" ]
            , p [ A.class "content" ] [ text injury.description ]
            ]
        ]


viewHow : Injury -> Html msg
viewHow injury =
    article [ A.class "tile is-child notification is-primary is-light" ]
        [ div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ p [ A.class "subtitle" ] [ text "How it happened" ]
            , p [ A.class "content" ] [ text injury.how ]
            ]
        ]


viewDates : Injury -> Maybe Date -> Html msg
viewDates injury today =
    let
        endDateToString =
            Maybe.map formatMMMMDY >> Maybe.withDefault "-"

        endDate =
            case injury.endDate of
                Nothing ->
                    today

                Just date ->
                    Just date
    in
    article [ A.class "tile is-child notification is-primary is-warning" ]
        [ p [ A.class "subtitle" ] [ text "When" ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ A.css [ displayFlex, flexDirection column, alignItems flexStart ] ]
                [ viewDateField (formatMMMMDY injury.startDate) "Start date"
                , viewDateField (endDateToString injury.endDate) "End date"
                , viewDateField (diffInDaysOfInjury injury.startDate endDate) "Days of injury"
                ]
            ]
        ]


diffInDaysOfInjury : Date -> Maybe Date -> String
diffInDaysOfInjury startDate endDate =
    case endDate of
        Nothing ->
            "not available"

        Just a ->
            String.fromInt <| diff Days startDate a


viewDateField : String -> String -> Html msg
viewDateField date titleLabel =
    div [ A.css [ displayFlex, width (pct 100), justifyContent spaceBetween ] ]
        [ label [] [ text titleLabel ]
        , label [] [ text date ]
        ]


tagsContainerStyle : Attribute msg
tagsContainerStyle =
    A.css [ displayFlex, marginBottom SP.medium, justifyContent spaceBetween ]
