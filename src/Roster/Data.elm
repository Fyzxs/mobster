module Roster.Data exposing (Mobster, RosterData, containsName, createMobster, currentMobsterNames, decode, decoder, empty, encoder, nextIndex, previousIndex, randomizeMobsters)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode as Encode
import Random
import Random.List
import Roster.Rpg as Rpg exposing (RpgData)


type alias Mobster =
    { name : String
    , rpgData : RpgData
    }


createMobster : String -> Mobster
createMobster name =
    { name = name, rpgData = Rpg.init }


type alias RosterData =
    { mobsters : List Mobster
    , inactiveMobsters : List Mobster
    , nextDriver : Int
    }


encoder : RosterData -> Encode.Value
encoder rosterData =
    Encode.object
        [ ( "mobsters", Encode.list encodeMobster rosterData.mobsters )
        , ( "inactiveMobsters", Encode.list encodeMobster rosterData.inactiveMobsters )
        , ( "nextDriver", Encode.int rosterData.nextDriver )
        ]


encodeMobster : Mobster -> Encode.Value
encodeMobster mobster =
    Encode.string mobster.name


empty : RosterData
empty =
    { mobsters = [], inactiveMobsters = [], nextDriver = 0 }


decoder : Decoder RosterData
decoder =
    Decode.succeed RosterData
        |> required "mobsters" (Decode.list Decode.string |> Decode.map mobsterNamesToMobsters)
        |> optional "inactiveMobsters" (Decode.list Decode.string |> Decode.map mobsterNamesToMobsters) []
        |> required "nextDriver" Decode.int


mobsterNamesToMobsters : List String -> List Mobster
mobsterNamesToMobsters mobsterNames =
    List.map stringToMobster mobsterNames


stringToMobster : String -> Mobster
stringToMobster name =
    Mobster name Rpg.init


decode : Encode.Value -> Result Decode.Error RosterData
decode data =
    Decode.decodeValue decoder data


randomizeMobsters : RosterData -> Random.Generator (List Mobster)
randomizeMobsters rosterData =
    Random.List.shuffle rosterData.mobsters


currentMobsterNames : RosterData -> String
currentMobsterNames rosterData =
    rosterData.mobsters
        |> List.map .name
        |> String.join ", "


nameExists : String -> List Mobster -> Bool
nameExists mobster list =
    list
        |> List.map .name
        |> List.map (\mobsterName -> String.toLower mobsterName)
        |> List.member (String.toLower mobster)


containsName : String -> RosterData -> Bool
containsName string rosterData =
    nameExists string rosterData.mobsters || nameExists string rosterData.inactiveMobsters


previousIndex : Int -> RosterData -> Int
previousIndex currentIndex rosterData =
    let
        mobSize =
            List.length rosterData.mobsters

        index =
            if mobSize == 0 then
                0

            else
                modBy mobSize (currentIndex - 1)
    in
    index


nextIndex : Int -> RosterData -> Int
nextIndex currentIndex rosterData =
    let
        mobSize =
            List.length rosterData.mobsters

        index =
            if mobSize == 0 then
                0

            else
                modBy mobSize (currentIndex + 1)
    in
    index
