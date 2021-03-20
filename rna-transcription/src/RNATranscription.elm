module RNATranscription exposing (toRNA, toRNA2, toRNA3)

import Maybe exposing (Maybe)
import String exposing (toList, uncons)


toRNAChar : Char -> Maybe String
toRNAChar letter =
    case letter of
        'G' ->
            Just "C"

        'C' ->
            Just "G"

        'T' ->
            Just "A"

        'A' ->
            Just "U"

        _ ->
            Nothing


toRNA : String -> Result String String
toRNA dna =
    case uncons dna of
        Nothing ->
            Ok ""

        Just ( dnaChar, dnaRest ) ->
            case ( toRNAChar dnaChar, toRNA dnaRest ) of
                ( Nothing, _ ) ->
                    Err "Invalid"

                ( _, Err errorMessage ) ->
                    Err errorMessage

                ( Just rnaChar, Ok rnaStr ) ->
                    Ok (String.concat [ rnaChar, rnaStr ])


toRNA2 : String -> Result String String
toRNA2 dna =
    toList
        |> List.foldl
            (\char all ->
                case all of
                    Err str ->
                        Err str

                    Ok rna ->
                        case toRNAChar char of
                            Nothing ->
                                Err "Invalid"

                            Just rnaChar ->
                                Ok (rna ++ rnaChar)
            )
            (Ok "")
            dna


sequenceFunc : Maybe a -> Maybe (List a) -> Maybe (List a)
sequenceFunc elem accum =
    case ( elem, accum ) of
        ( Nothing, _ ) ->
            Nothing

        ( _, Nothing ) ->
            Nothing

        ( Just x, Just xs ) ->
            Just (List.append xs [ x ])


sequence : List (Maybe a) -> Maybe (List a)
sequence =
    List.foldl sequenceFunc (Just [])


toRNA3 : String -> Result String String
toRNA3 dna =
    case sequence (List.map toRNAChar (toList dna)) of
        Nothing ->
            Err "Invalid"

        Just rnaChars ->
            Ok (String.concat rnaChars)
