module Triangle exposing (rows)

import List exposing (maximum)


genNextRow : List Int -> List Int
genNextRow prev =
    genNextRowRec <| 0 :: prev ++ [ 0 ]


genNextRowRec : List Int -> List Int
genNextRowRec prevRow =
    case prevRow of
        fst :: scnd :: rest ->
            fst + scnd :: genNextRowRec (scnd :: rest)

        _ ->
            []


row : Int -> List (List Int) -> List (List Int)
row rowNum prevRows =
    case ( rowNum, prevRows ) of
        ( 0, _ ) ->
            []

        ( 1, _ ) ->
            [ [ 1 ] ]

        ( _, [] ) ->
            []

        ( _, prevRow :: otherRows ) ->
            genNextRow prevRow :: (prevRow :: otherRows)


rows : Int -> List (List Int)
rows n =
    maximum [ 0, n ]
        |> Maybe.withDefault 0
        |> List.range 0
        |> List.foldl row []
        |> List.reverse
