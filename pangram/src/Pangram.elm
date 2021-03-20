module Pangram exposing (isPangram)

import Regex
import Set


onlyEnglishLetters : String -> String
onlyEnglishLetters =
    let
        regex =
            Maybe.withDefault Regex.never (Regex.fromString "[^a-zA-Z]")
    in
    Regex.replace regex (always "")


isPangram : String -> Bool
isPangram =
    (==) 26
        << Set.size
        << Set.fromList
        << String.toList
        << String.toLower
        << onlyEnglishLetters
