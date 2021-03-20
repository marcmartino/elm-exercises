module MatchingBrackets exposing (isPaired)

import Maybe
import Regex


type BracketStackItem
    = Paren
    | Bracket
    | Curly


bracketStackCons : BracketStackItem -> Maybe (List BracketStackItem) -> Maybe (List BracketStackItem)
bracketStackCons item =
    Maybe.map (\xs -> item :: xs)


bracketRemoveHead : BracketStackItem -> Maybe (List BracketStackItem) -> Maybe (List BracketStackItem)
bracketRemoveHead item =
    Maybe.andThen
        (\stack ->
            case stack of
                x :: xs ->
                    if x == item then
                        Just xs

                    else
                        Nothing

                [] ->
                    Nothing
        )


isEmpty : Maybe (List a) -> Bool
isEmpty =
    Maybe.withDefault False << Maybe.map List.isEmpty


sanitize : String -> String
sanitize input =
    Maybe.withDefault "" <|
        Maybe.map (\reg -> Regex.replace reg (\_ -> "") input) <|
            Regex.fromString "[^\\(\\)\\[\\]{}]"


checkBrackets : Char -> Maybe (List BracketStackItem) -> Maybe (List BracketStackItem)
checkBrackets char bkts =
    case char of
        '(' ->
            bracketStackCons Paren bkts

        '[' ->
            bracketStackCons Bracket bkts

        '{' ->
            bracketStackCons Curly bkts

        ')' ->
            bracketRemoveHead Paren bkts

        ']' ->
            bracketRemoveHead Bracket bkts

        '}' ->
            bracketRemoveHead Curly bkts

        _ ->
            Nothing


isPaired : String -> Bool
isPaired =
    isEmpty << String.foldl checkBrackets (Just []) << sanitize
