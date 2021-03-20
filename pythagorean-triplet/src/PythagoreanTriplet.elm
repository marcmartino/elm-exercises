module PythagoreanTriplet exposing (..)


type alias Triplet =
    ( Int, Int, Int )


lowerBounds : Int -> List Int
lowerBounds x =
    List.range 2 (x // 3)


mids : Int -> Int -> List Int
mids x y =
    List.range (y + 1) ((x - y) // 2)


generateTriplet : Int -> Int -> Int -> List Triplet
generateTriplet num x y =
    if x ^ 2 + y ^ 2 == (num - x - y) ^ 2 then
        [ ( x, y, num - x - y ) ]

    else
        []


minTriplet : Int -> Int -> List Triplet
minTriplet num x =
    List.concatMap
        (generateTriplet num x)
        (mids num x)


triplets : Int -> List Triplet
triplets n =
    List.concatMap (minTriplet n) (List.range 2 (n // 3))
