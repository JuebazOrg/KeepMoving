module Pages.InjuryDetails.DetailsComponents exposing (..)

import Components.Elements as C
import Css exposing (..)
import Date exposing (Date, Unit(..), diff)
import Domain.CheckPoint exposing (CheckPoint)
import Domain.Injury exposing (..)
import Domain.Regions exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events exposing (..)
import Pages.InjuryDetails.CheckPoints as CheckPoints
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


viewDates : Injury -> Html msg
viewDates injury =
    let
        endDateToString =
            Maybe.map formatMMMMDY >> Maybe.withDefault "-"
    in
    article [ A.class "tile is-child notification is-primary is-warning" ]
        [ p [ A.class "subtitle" ] [ text "When" ]
        , div [ A.class "content", A.css [ displayFlex, flexDirection column ] ]
            [ div [ A.css [ displayFlex, flexDirection column, alignItems flexStart ] ]
                [ viewDateField (formatMMMMDY injury.startDate) "Start date"
                , viewDateField (endDateToString injury.endDate) "End date"
                , viewDateField (String.fromInt (diffInDaysOfInjury injury.startDate injury.endDate)) "Days of injury"
                ]
            ]
        ]


diffInDaysOfInjury : Date -> Maybe Date -> Int
diffInDaysOfInjury startDate endDate =
    diff Days startDate startDate


viewDateField : String -> String -> Html msg
viewDateField date titleLabel =
    div [ A.css [ displayFlex, width (pct 100), justifyContent spaceBetween ] ]
        [ label [] [ text titleLabel ]
        , label [] [ text date ]
        ]


tagsContainerStyle : Attribute msg
tagsContainerStyle =
    A.css [ displayFlex, marginBottom SP.medium, justifyContent spaceBetween ]
