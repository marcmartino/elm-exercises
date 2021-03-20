module NucleotideCount exposing (nucleotideCounts)


type alias NucleotideCounts =
    { a : Int
    , t : Int
    , c : Int
    , g : Int
    }


emptyNucCount : NucleotideCounts
emptyNucCount =
    { a = 0
    , t = 0
    , c = 0
    , g = 0
    }


countLetters : Char -> NucleotideCounts -> NucleotideCounts
countLetters letter allCounts =
    case letter of
        'A' ->
            { allCounts | a = (+) 1 <| allCounts.a }

        'T' ->
            { allCounts | t = (+) 1 <| allCounts.t }

        'C' ->
            { allCounts | c = (+) 1 <| allCounts.c }

        'G' ->
            { allCounts | g = (+) 1 <| allCounts.g }

        _ ->
            allCounts


nucleotideCounts : String -> NucleotideCounts
nucleotideCounts =
    String.toList
        >> List.foldl countLetters emptyNucCount
