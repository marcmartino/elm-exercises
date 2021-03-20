module CollatzConjecture exposing (collatz)


collatzStepCount : Int -> Int
collatzStepCount n =
    if n == 1 then
        0

    else if modBy 2 n |> (==) 0 then
        1 + (collatzStepCount <| n // 2)

    else
        1 + (collatzStepCount <| 3 * n + 1)


validNumber : Int -> Result String Int
validNumber x =
    if x > 0 then
        Ok x

    else
        Err "Only positive numbers are allowed"


collatz : Int -> Result String Int
collatz =
    validNumber
        >> Result.map collatzStepCount
