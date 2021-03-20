module Isogram exposing (isIsogram)

import Regex exposing (Regex)
import Set exposing (Set)


sanitizeNonLetters : String -> String
sanitizeNonLetters =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromString "[^\\w]"
    in
    Regex.replace regex (always "")


isJust : Maybe a -> Bool
isJust m =
    case m of
        Just _ ->
            True

        _ ->
            False


charToSet : Char -> Maybe (Set Char) -> Maybe (Set Char)
charToSet c =
    Maybe.andThen
        (\chars ->
            if Set.member c chars then
                Nothing

            else
                Just (Set.insert c chars)
        )


isIsogram : String -> Bool
isIsogram =
    String.toLower
        >> sanitizeNonLetters
        >> String.toList
        >> List.foldl charToSet (Just Set.empty)
        >> isJust
