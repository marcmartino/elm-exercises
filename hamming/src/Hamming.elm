module Hamming exposing (distance)


toListOfTuples : ( List a, List b ) -> Maybe (List ( a, b ))
toListOfTuples tup =
    if List.length (Tuple.first tup) /= List.length (Tuple.second tup) then
        Nothing

    else
        case tup of
            ( [], _ ) ->
                Just []

            ( _, [] ) ->
                Just []

            ( x :: xs, y :: ys ) ->
                Maybe.map (\tupls -> ( x, y ) :: tupls) (toListOfTuples ( xs, ys ))


countDiffs : ( comparable, comparable ) -> Int -> Int
countDiffs compTupl differenceCount =
    if Tuple.first compTupl /= Tuple.second compTupl then
        differenceCount + 1

    else
        differenceCount


distance : String -> String -> Result String Int
distance left right =
    case toListOfTuples (Tuple.pair (String.split "" left) (String.split "" right)) of
        Nothing ->
            Err "left and right strands must be of equal length"

        Just cells ->
            Ok (List.foldl countDiffs 0 cells)
