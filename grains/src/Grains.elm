module Grains exposing (square, sumSquares)


validSquareNumber : Int -> Maybe Int
validSquareNumber num =
    if num > 0 && num <= 64 then
        Just num

    else
        Nothing


mapAndFold : (a -> b) -> (b -> c -> c) -> c -> List a -> c
mapAndFold map fold default =
    List.foldl (\x accum -> fold (map x) accum) default


sumSquares : Int -> Maybe Int
sumSquares =
    validSquareNumber
        >> Maybe.map
            ((+) -1
                >> List.range 0
                >> mapAndFold ((^) 2) (+) 0
            )


square : Int -> Maybe Int
square =
    validSquareNumber >> Maybe.map ((+) -1 >> (^) 2)
