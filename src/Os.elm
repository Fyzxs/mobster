module Os exposing (Os(..), ctrlKeyString)


type Os
    = Mac
    | NotMac


ctrlKeyString : Os -> String
ctrlKeyString os =
    case os of
        Mac ->
            "⌘"

        NotMac ->
            "Ctrl"
