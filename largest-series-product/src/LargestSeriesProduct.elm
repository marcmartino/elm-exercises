module LargestSeriesProduct exposing (largestProduct)

import Regex exposing (Regex)


isNumerical : String -> Bool
isNumerical =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromString "[^\\d]"
    in
    Regex.findAtMost 1 regex >> List.length >> (==) 0


isValid : Int -> String -> Maybe ()
isValid len series =
    if len <= String.length series && len >= 0 && isNumerical series then
        Just ()

    else
        Nothing


findLargestProduct : Int -> List Int -> Int
findLargestProduct length =
    genGroupings length
        >> List.map (List.foldl (*) 1)
        >> List.maximum
        >> Maybe.withDefault 1


toNumList : String -> List Int
toNumList =
    String.toList
        >> List.map (String.fromChar >> String.toInt >> Maybe.withDefault 0)


genGroupings : Int -> List Int -> List (List Int)
genGroupings l xList =
    if List.length xList < l then
        []

    else
        case xList of
            [] ->
                []

            x :: xs ->
                List.take l (x :: xs) :: genGroupings l xs


largestProduct : Int -> String -> Maybe Int
largestProduct length series =
    isValid length series
        |> Maybe.map (always (toNumList series))
        |> Maybe.map (findLargestProduct length)
