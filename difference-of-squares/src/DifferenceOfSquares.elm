module DifferenceOfSquares exposing (difference, squareOfSum, sumOfSquares)


squareOfSum : Int -> Int
squareOfSum n =
    List.foldl (+) 0 (List.range 1 n) ^ 2


sumOfSquares : Int -> Int
sumOfSquares n =
    List.foldl (\x a -> a + x ^ 2) 1 (List.range 2 n)


difference : Int -> Int
difference n =
    squareOfSum n - sumOfSquares n
