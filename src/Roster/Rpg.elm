module Roster.Rpg exposing (Experience, Goal, RpgData, badges, init)

import ListHelpers exposing (compact)
import Roster.RpgRole exposing (RpgRole(..))


type alias Experience =
    List Goal


type alias Goal =
    { complete : Int
    , description : String
    }


type alias RpgData =
    { driver : Experience
    , navigator : Experience
    , mobber : Experience
    , researcher : Experience
    , sponsor : Experience
    }


something : RpgData -> List ( RpgRole, Experience )
something rpgData =
    [ ( Driver, rpgData.driver )
    , ( Navigator, rpgData.navigator )
    , ( Mobber, rpgData.mobber )
    , ( Researcher, rpgData.researcher )
    , ( Sponsor, rpgData.sponsor )
    ]


badges : RpgData -> List RpgRole
badges rpgData =
    let
        completeBadges =
            rpgData
                |> something
                |> List.map somethingToBadge
                |> compact
    in
    completeBadges


somethingToBadge : ( RpgRole, Experience ) -> Maybe RpgRole
somethingToBadge ( role, experience ) =
    let
        goalCount =
            experience
                |> List.map .complete
                |> List.sum
    in
    if goalCount > 2 then
        Just role

    else
        Nothing


init : RpgData
init =
    { driver =
        experienceThings
            [ "Ask a clarifying question about what to type"
            , "Type something you disagree with"
            , "Use a new keyboard shortcut"
            , "Learn something new about tooling"
            , "Ignore a direct instruction from someone who isn't the Navigator"
            ]
    , navigator =
        experienceThings
            [ "Ask for ideas"
            , "Filter the mob's ideas then tell the Driver exactly what to type"
            , "Tell the Driver only your high-level intent and have them implement the details"
            , "Create a failing test. Make it pass. Refactor."
            ]
    , mobber =
        experienceThings
            [ "Yield to the less privileged voice"
            , "Contribute an idea"
            , "Ask questions till you understand"
            , "Listen on the edge of your seat"
            ]
    , researcher =
        experienceThings
            [ "Find and share relevant information from documentation"
            , "Find and share relevant information from a blog"
            , "Find and share relevant information from a coding forum"
            ]
    , sponsor =
        experienceThings
            [ "Amplify the unheard voice"
            , "Pick the mobber with the least privilege (gender/race/class/seniority/etc) and support their contributions"
            , "Celebrate moments of excellence"
            ]
    }


experienceThings : List String -> Experience
experienceThings stringList =
    List.map initGoal stringList


initGoal : String -> Goal
initGoal description =
    { complete = 0, description = description }
