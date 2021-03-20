module ArmstrongNumbers exposing (isArmstrongNumber)

import List


charToNum : Char -> Int
charToNum =
    String.fromChar >> String.toInt >> Maybe.withDefault 0


digitList : Int -> List Int
digitList =
    String.fromInt
        >> String.toList
        >> List.map charToNum


isArmstrongNumber : Int -> Bool
isArmstrongNumber num =
    let
        numList =
            digitList num
    in
    numList
        |> List.map (\x -> x ^ List.length numList)
        |> List.sum
        |> (==) num
