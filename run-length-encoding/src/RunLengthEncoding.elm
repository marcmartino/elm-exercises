module RunLengthEncoding exposing (decode, encode, encodedToCounts)

import Maybe
import Regex
import String


charToInt : Char -> Int
charToInt =
    Maybe.withDefault 0 << String.toInt << String.fromChar


sanitize : String -> String -> String
sanitize regexStr =
    let
        invalidChars =
            Maybe.withDefault Regex.never <| Regex.fromString regexStr
    in
    Regex.replace invalidChars (always "")


sanitizeBeforeEncoding : String -> String
sanitizeBeforeEncoding =
    sanitize "[^ A-z]"


sanitizeBeforeDecoding : String -> String
sanitizeBeforeDecoding =
    sanitize "[^ 0-9A-z]"


countDuplicates : a -> List ( a, Int ) -> List ( a, Int )
countDuplicates next counts =
    case counts of
        ( prev, count ) :: xs ->
            if next == prev then
                ( prev, count + 1 ) :: xs

            else
                ( next, 1 ) :: counts

        [] ->
            [ ( next, 1 ) ]


combineCounts : ( Char, Int ) -> String -> String
combineCounts count =
    (++) <|
        ((\c ->
            if c == 1 then
                ""

            else
                String.fromInt c
         )
         <|
            Tuple.second count
        )
            ++ (String.fromChar <| Tuple.first count)


encode : String -> String
encode =
    List.foldl combineCounts ""
        << String.foldl countDuplicates []
        << sanitizeBeforeEncoding


expandCounts : ( Char, Int ) -> List Char
expandCounts count =
    List.map (always (Tuple.first count)) <| List.range 1 (Tuple.second count)


encodedToCounts : Int -> List Char -> List ( Char, Int )
encodedToCounts pendingCount chars =
    case chars of
        c :: cs ->
            if Char.isDigit c then
                encodedToCounts ((pendingCount * 10) + charToInt c) cs

            else
                ( c, max pendingCount 1 ) :: encodedToCounts 0 cs

        [] ->
            []


decode : String -> String
decode =
    String.fromList
        << List.concatMap expandCounts
        << encodedToCounts 0
        << String.toList
        << sanitizeBeforeDecoding
