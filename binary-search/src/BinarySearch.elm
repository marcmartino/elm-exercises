module BinarySearch exposing (find)

import Array exposing (Array)


type Comparison
    = EQ
    | GT
    | LT
    | NEQ


elemComparison : comparable -> comparable -> Comparison
elemComparison baseline val =
    if baseline == val then
        EQ

    else if baseline < val then
        LT

    else if baseline > val then
        GT

    else
        NEQ


find : Int -> Array Int -> Maybe Int
find target xs =
    if Array.isEmpty xs then
        Nothing

    else
        let
            middleI =
                floor <| (*) 0.5 <| toFloat <| Array.length xs
        in
        case Maybe.map (elemComparison target) (Array.get middleI xs) of
            Just EQ ->
                Just middleI

            Just GT ->
                Maybe.map ((+) (middleI + 1)) (find target (Array.slice (middleI + 1) ((+) 1 <| Array.length xs) xs))

            Just LT ->
                find target (Array.slice 0 middleI xs)

            _ ->
                Nothing
