module RomanNumerals exposing (toRoman)


type alias RomanNumls =
    List ( Int, String )


romanNumerals : RomanNumls
romanNumerals =
    [ ( 1000, "M" ), ( 500, "D" ), ( 100, "C" ), ( 50, "L" ), ( 10, "X" ), ( 5, "V" ), ( 1, "I" ) ]


isCompleteableWithSubtraction : RomanNumls -> Int -> Int -> Bool
isCompleteableWithSubtraction numls baseNum target =
    case numls of
        ( romanVal, _ ) :: otherNumls ->
            if baseNum - romanVal == target then
                True

            else
                isCompleteableWithSubtraction otherNumls baseNum target

        [] ->
            False


narrowDownRomanNumerals : RomanNumls -> Int -> String
narrowDownRomanNumerals numerals number =
    case numerals of
        [ ( numlV, numlL ) ] ->
            String.repeat (number // numlV) numlL

        ( numlV, numlL ) :: ( lesserNumlV, lesserNumlL ) :: otherNumls ->
            if modBy numlV number == 0 && (number // numlV) <= 3 then
                String.repeat (number // numlV) numlL

            else if number < numlV && number > lesserNumlV && isCompleteableWithSubtraction (( lesserNumlV, lesserNumlL ) :: otherNumls) numlV number then
                narrowDownRomanNumerals (( lesserNumlV, lesserNumlL ) :: otherNumls) (numlV - number) ++ numlL

            else if number < numlV && number > lesserNumlV && modBy lesserNumlV number /= 0 then
                lesserNumlL ++ narrowDownRomanNumerals otherNumls (number - lesserNumlV)

            else
                narrowDownRomanNumerals (( lesserNumlV, lesserNumlL ) :: otherNumls) number

        _ ->
            ""


digitToRomanNumeral : Int -> String
digitToRomanNumeral =
    narrowDownRomanNumerals romanNumerals


toDigitValues : Int -> List Int
toDigitValues =
    String.fromInt
        >> String.toList
        >> List.map
            (String.fromChar
                >> String.toInt
                >> Maybe.withDefault 0
            )
        >> List.reverse
        >> List.indexedMap (\i digit -> digit * (10 ^ i))
        >> List.filter ((/=) 0)


toRoman : Int -> String
toRoman =
    toDigitValues
        >> List.map digitToRomanNumeral
        >> List.foldl (++) ""
