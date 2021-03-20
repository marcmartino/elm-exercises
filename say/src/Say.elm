module Say exposing (SayError(..), say)

import Html exposing (a)


type SayError
    = Negative
    | TooLarge


type alias ThreeDigitNumber =
    ( Int, Int, Int )


singleDigitName : Int -> Maybe String
singleDigitName num =
    case num of
        1 ->
            Just "one"

        2 ->
            Just "two"

        3 ->
            Just "three"

        4 ->
            Just "four"

        5 ->
            Just "five"

        6 ->
            Just "six"

        7 ->
            Just "seven"

        8 ->
            Just "eight"

        9 ->
            Just "nine"

        _ ->
            Nothing


teenDigitsName : Int -> Maybe String
teenDigitsName num =
    case num of
        10 ->
            Just "ten"

        11 ->
            Just "eleven"

        12 ->
            Just "twelve"

        13 ->
            Just "thirteen"

        14 ->
            Just "fourteen"

        15 ->
            Just "fifteen"

        16 ->
            Just "sixteen"

        17 ->
            Just "seventeen"

        18 ->
            Just "eighteen"

        19 ->
            Just "nineteen"

        _ ->
            Nothing


tensName : Int -> Maybe String
tensName num =
    case num of
        1 ->
            Just "ten"

        2 ->
            Just "twenty"

        3 ->
            Just "thirty"

        4 ->
            Just "forty"

        5 ->
            Just "fifty"

        6 ->
            Just "sixty"

        7 ->
            Just "seventy"

        8 ->
            Just "eighty"

        9 ->
            Just "nintey"

        _ ->
            Nothing


digitGroupName : Int -> Maybe String
digitGroupName num =
    case num of
        0 ->
            Just ""

        1 ->
            Just "thousand"

        2 ->
            Just "million"

        3 ->
            Just "billion"

        4 ->
            Just "trillion"

        5 ->
            Just "quadrillion"

        6 ->
            Just "quintrillion"

        7 ->
            Just "sentillion"

        8 ->
            Just "septillion"

        _ ->
            Nothing


toIntList : Int -> List Int
toIntList num =
    let
        negativeMultiplier =
            if num >= 0 then
                1

            else
                -1
    in
    num
        |> String.fromInt
        |> String.toList
        |> List.map
            (String.fromChar
                >> String.toInt
                >> Maybe.withDefault 0
            )
        |> (\digits ->
                case digits of
                    d :: ds ->
                        d * negativeMultiplier :: ds

                    [] ->
                        []
           )


groupList : Int -> List a -> List (List a)
groupList groupSize list =
    case list of
        [] ->
            []

        _ ->
            List.take groupSize list :: groupList groupSize (List.drop groupSize list)


toTriple : List Int -> ThreeDigitNumber
toTriple list =
    case list of
        [ x ] ->
            ( 0, 0, x )

        [ x, y ] ->
            ( 0, x, y )

        [ x, y, z ] ->
            ( x, y, z )

        _ ->
            ( 0, 0, 0 )


groupOrdersOfMagnitude : Int -> List ThreeDigitNumber
groupOrdersOfMagnitude =
    abs
        >> toIntList
        >> List.reverse
        >> groupList 3
        >> List.map List.reverse
        >> List.reverse
        >> List.map toTriple


addOrdersOfMagnitude : List String -> List String
addOrdersOfMagnitude =
    let
        addMagnitude : ( Int, String ) -> String
        addMagnitude =
            \( i, words ) -> words ++ " " ++ Maybe.withDefault "" (digitGroupName i)
    in
    List.reverse
        >> List.indexedMap (\i words -> ( i, words ))
        >> List.filter (\( _, words ) -> words /= "")
        >> List.filter (\( i, words ) -> not (i == 0 && words == "zero"))
        >> List.map addMagnitude
        >> List.reverse


negativeName : Int -> String
negativeName num =
    if num < 0 then
        "negative"

    else
        ""


getSingleDigitName : Int -> List (Maybe String)
getSingleDigitName digit =
    [ singleDigitName <| digit ]


getHundredsWords : Int -> List (Maybe String)
getHundredsWords digit =
    case digit of
        0 ->
            []

        _ ->
            [ singleDigitName digit, Just "hundred" ]


hyphenate : Maybe String -> Maybe String -> Maybe String
hyphenate a b =
    case ( a, b ) of
        ( Just first, Just second ) ->
            Just <| first ++ "-" ++ second

        _ ->
            Nothing


getTensAndOnesWords : Int -> Int -> List (Maybe String)
getTensAndOnesWords tens ones =
    case ( tens, ones ) of
        ( 0, 0 ) ->
            []

        ( 0, _ ) ->
            getSingleDigitName ones

        ( 1, _ ) ->
            [ teenDigitsName (tens * 10 + ones) ]

        ( _, 0 ) ->
            [ tensName tens ]

        _ ->
            [ hyphenate (tensName tens) (Just (String.join " " (filterNothings (getSingleDigitName ones)))) ]


filterNothings : List (Maybe a) -> List a
filterNothings items =
    case items of
        (Just x) :: xs ->
            x :: filterNothings xs

        Nothing :: xs ->
            filterNothings xs

        [] ->
            []


digitsToSpokenNumber : ThreeDigitNumber -> String
digitsToSpokenNumber ( hundreds, tens, ones ) =
    let
        hundredsText =
            getHundredsWords hundreds

        tensText =
            getTensAndOnesWords tens ones

        andText =
            if List.length hundredsText > 0 && List.length tensText > 0 then
                [ Just "and" ]

            else
                []

        text =
            if hundreds == 0 && tens == 0 && ones == 0 then
                []

            else
                List.concat
                    [ hundredsText
                    , andText
                    , tensText
                    ]
    in
    text
        |> filterNothings
        |> String.join " "



-- isValidNumber is needed for the project tests
-- however the program is equipped to handle negative numbers and numbers up 1q
isValidNumber : Int -> Result SayError Int
isValidNumber num =
    if num < 0 then
        Err Negative

    else if num >= 1000000000000 then
        Err TooLarge

    else
        Ok num


defaultToZero : String -> String
defaultToZero num =
    if String.length num == 0 then
        "zero"

    else
        num


say : Int -> Result SayError String
say num =
    let
        appendNegative =
            List.append [ negativeName num ]
    in
    num
        |> isValidNumber
        |> Result.map
            (groupOrdersOfMagnitude
                >> List.map digitsToSpokenNumber
                >> addOrdersOfMagnitude
                >> appendNegative
                >> String.join " "
                >> String.trim
                >> defaultToZero
            )
