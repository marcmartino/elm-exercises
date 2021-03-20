module AllYourBase exposing (rebase)


validInputs : Int -> List Int -> Int -> Maybe ()
validInputs startBase digits endBase =
    let
        onlyPositiveDigits =
            List.all ((<=) 0)

        someNonzero =
            List.any ((<=) 1)

        allDigitsWinthinBase =
            List.all ((>) startBase)
    in
    if
        startBase
            > 0
            && endBase
            > 0
            && List.length digits
            > 0
            && onlyPositiveDigits digits
            && someNonzero digits
            && allDigitsWinthinBase digits
    then
        Just ()

    else
        Nothing


toDecimal : Int -> List Int -> Int
toDecimal base =
    List.reverse
        >> List.indexedMap (\place digit -> digit * (base ^ place))
        >> List.sum


fromDecimal : Int -> Int -> List Int
fromDecimal base num =
    let
        newDigitsLen : Int
        newDigitsLen =
            round (logBase 10 (toFloat num) / logBase 10 (toFloat base))
    in
    countDigits base newDigitsLen num
        |> removeLeadingZeros


removeLeadingZeros : List Int -> List Int
removeLeadingZeros list =
    case list of
        0 :: xs ->
            removeLeadingZeros xs

        _ ->
            list


countDigits : Int -> Int -> Int -> List Int
countDigits base placeNum num =
    if placeNum < 0 then
        []

    else
        num // (base ^ placeNum) :: countDigits base (placeNum - 1) (modBy (base ^ placeNum) num)


rebase : Int -> List Int -> Int -> Maybe (List Int)
rebase inBase digits outBase =
    validInputs inBase digits outBase
        |> Maybe.map (\_ -> toDecimal inBase digits)
        |> Maybe.map (fromDecimal outBase)
