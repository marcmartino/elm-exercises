module Bob exposing (hey)

import Regex exposing (Regex)


type Sentence
    = Question String
    | Statement String
    | Nonsense String
    | Silence


hasUppercaseLetters : Regex
hasUppercaseLetters =
    Regex.contains <| Maybe.withDefault Regex.never <| Regex.fromString "[A-Z]+"


isYelling : String -> Bool
isYelling str =
    (&&) (hasUppercaseLetters str) <| (==) str <| String.toUpper <| str


getSentenceType : String -> Sentence
getSentenceType str =
    let
        trimmed =
            String.trim str

        question =
            String.endsWith "?" trimmed

        statement =
            String.endsWith "." trimmed
    in
    if question then
        Question trimmed

    else if statement then
        Statement trimmed

    else if String.length trimmed == 0 then
        Silence

    else
        Nonsense trimmed


hey : String -> String
hey remark =
    case ( getSentenceType remark, isYelling remark ) of
        ( Question _, False ) ->
            "Sure."

        ( Question _, True ) ->
            "Calm down, I know what I'm doing!"

        ( Silence, _ ) ->
            "Fine. Be that way!"

        ( Statement _, True ) ->
            "Whoa, chill out!"

        ( Nonsense _, True ) ->
            "Whoa, chill out!"

        _ ->
            "Whatever."
