module Series exposing (slices)


sliceLengthLTSeries : String -> Int -> Result String Int
sliceLengthLTSeries str size =
    if String.length str >= size then
        Ok size

    else
        Err "slice length cannot be greater than series length"


sliceLengthPositive : Int -> Result String Int
sliceLengthPositive size =
    if size >= 0 then
        Ok size

    else
        Err "slice length cannot be negative"


sliceLengthNonZero : Int -> Result String Int
sliceLengthNonZero size =
    if size /= 0 then
        Ok size

    else
        Err "slice length cannot be zero"


emptySeries : String -> Result String String
emptySeries series =
    if String.length series /= 0 then
        Ok series

    else
        Err "series cannot be empty"


validation : Int -> String -> Result String ()
validation size input =
    input
        |> emptySeries
        |> Result.map (always size)
        |> Result.andThen (sliceLengthLTSeries input)
        |> Result.andThen sliceLengthPositive
        |> Result.andThen sliceLengthNonZero
        |> Result.map (always ())


seriesToList : String -> List Int
seriesToList =
    String.toList
        >> List.map (String.fromChar >> String.toInt >> Maybe.withDefault 0)


getSlices : Int -> List Int -> List (List Int)
getSlices size series =
    if size > List.length series then
        []

    else
        case series of
            [] ->
                []

            _ :: seriesRest ->
                List.take size series :: getSlices size seriesRest


slices : Int -> String -> Result String (List (List Int))
slices size input =
    validation size input
        |> Result.map (always <| seriesToList <| input)
        |> Result.map (getSlices size)
