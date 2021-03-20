module WordCount exposing (wordCount)

import Dict exposing (Dict)
import Regex


sanitizeInput : String -> String
sanitizeInput =
    let
        specialCharsRegex =
            Maybe.withDefault Regex.never <| Regex.fromString "([^\\s\\w']|'\\s|\\s'|'$)"

        whiteSpaceCharsRegex =
            Maybe.withDefault Regex.never <| Regex.fromString "(\\s{2,}|\\s)"
    in
    Regex.replace specialCharsRegex (always " ")
        >> Regex.replace whiteSpaceCharsRegex (always " ")
        >> String.trim


toFrequencyCount : Dict String Int -> List String -> Dict String Int
toFrequencyCount prevFrequencies words =
    case words of
        [] ->
            prevFrequencies

        word :: otherWords ->
            let
                newFrequency =
                    Maybe.withDefault 0 (Dict.get word prevFrequencies) + 1
            in
            toFrequencyCount (Dict.insert word newFrequency prevFrequencies) otherWords


wordCount : String -> Dict String Int
wordCount =
    String.toLower
        >> sanitizeInput
        >> String.split " "
        >> toFrequencyCount Dict.empty
