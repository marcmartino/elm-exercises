module SumOfMultiples exposing (sumOfMultiples)


multsUpTo : Int -> Int -> List Int
multsUpTo max mult =
    mult
        |> (//) (max - 1)
        |> List.range 1
        |> List.map ((*) mult)



-- sumOfMultiples : List Int -> Int -> Int
-- sumOfMultiples divisors limit =
--     List.concatMap (multsUpTo limit) divisors
--         |> Set.fromList
--         |> Set.toList
--         |> List.sum


notDivBy : Int -> Int -> Bool
notDivBy x =
    modBy x >> (/=) 0


and : (a -> Bool) -> (a -> Bool) -> a -> Bool
and pred1 pred2 x =
    pred1 x && pred2 x


genNums : (Int -> Bool) -> List Int -> Int -> List Int
genNums numCondition divisors limit =
    case divisors of
        div :: restDivs ->
            (multsUpTo limit div |> List.filter numCondition)
                ++ genNums (and numCondition (notDivBy div)) restDivs limit

        [] ->
            []


sumOfMultiples : List Int -> Int -> Int
sumOfMultiples divisors limit =
    genNums (always True) divisors limit
        |> List.sum
