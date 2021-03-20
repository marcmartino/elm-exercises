module ScrabbleScore exposing (scoreWord, scoreWordWithBonuses)

import Dict exposing (Dict)


type Tile
    = StandardTile Char
    | DoubleLetterTile Char
    | TripleLetterTile Char
    | DoubleWordTile Char
    | TripleWordTile Char


scoreCategories : List ( String, Int )
scoreCategories =
    [ ( "A, E, I, O, U, L, N, R, S, T", 1 )
    , ( "D, G", 2 )
    , ( "B, C, M, P", 3 )
    , ( "F, H, V, W, Y", 4 )
    , ( "K", 5 )
    , ( "J, X", 8 )
    , ( "Q, Z", 10 )
    ]


letterCategories : String -> List Char
letterCategories =
    String.toList << String.replace ", " ""


scoreLetterGroupToPairs : ( String, Int ) -> List ( Char, Int )
scoreLetterGroupToPairs letterGroupScorePair =
    List.map (\char -> ( char, Tuple.second letterGroupScorePair )) (letterCategories (Tuple.first letterGroupScorePair))


letterScores : Dict Char Int
letterScores =
    let
        letterPairs =
            List.concatMap scoreLetterGroupToPairs scoreCategories
    in
    List.foldl (\pair dict -> Dict.insert (Tuple.first pair) (Tuple.second pair) dict) Dict.empty letterPairs


calculateScore : List Char -> Int
calculateScore letters =
    case letters of
        [] ->
            0

        x :: xs ->
            Maybe.withDefault 0 (Dict.get x letterScores) + calculateScore xs


scoreWord : String -> Int
scoreWord =
    calculateScore << String.toList << String.toUpper


aggregateTileScores : Tile -> ( Int, Int ) -> ( Int, Int )
aggregateTileScores tile score =
    let
        wordMult =
            Tuple.first score

        currScore =
            Tuple.second score
    in
    case tile of
        StandardTile t ->
            ( wordMult, currScore + calculateScore [ t ] )

        DoubleLetterTile t ->
            ( wordMult, currScore + calculateScore [ t ] * 2 )

        TripleLetterTile t ->
            ( wordMult, currScore + calculateScore [ t ] * 3 )

        DoubleWordTile t ->
            ( wordMult * 2, currScore + calculateScore [ t ] )

        TripleWordTile t ->
            ( wordMult * 3, currScore + calculateScore [ t ] )


scoreWordWithBonuses : List Tile -> Int
scoreWordWithBonuses letters =
    let
        scoreTupl =
            List.foldl aggregateTileScores ( 1, 0 ) letters
    in
    Tuple.first scoreTupl * Tuple.second scoreTupl
