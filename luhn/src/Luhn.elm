module Luhn exposing (valid, validChars, validChecksum, validLength)

import Regex exposing (Regex)
import String


boolMaybe : Bool -> Maybe ()
boolMaybe b =
    if b then
        Just ()

    else
        Nothing


sequence : List (Maybe a) -> Maybe (List a)
sequence list =
    case list of
        [] ->
            Just []

        (Just x) :: xs ->
            Maybe.map (\rest -> x :: rest) <| sequence xs

        Nothing :: _ ->
            Nothing


isJust : Maybe a -> Bool
isJust mb =
    case mb of
        Just _ ->
            True

        Nothing ->
            False


replaceRegex : String -> String -> String
replaceRegex regexStr =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromString <| regexStr
    in
    Regex.replace regex (always "")


onlyNumbers : String -> String
onlyNumbers =
    replaceRegex "[^\\d]"


validLength : String -> Maybe ()
validLength =
    onlyNumbers
        >> String.length
        >> (\len -> len > 1 && len <= 16)
        >> boolMaybe


validChars : String -> Maybe ()
validChars str =
    let
        invalidChars : Regex
        invalidChars =
            Maybe.withDefault Regex.never (Regex.fromString "[^\\d\\s]")
    in
    str
        |> Regex.contains invalidChars
        |> not
        |> boolMaybe


toListOfDigits : String -> Maybe (List Int)
toListOfDigits =
    replaceRegex "[^\\d]"
        >> String.toList
        >> List.map (String.fromChar >> String.toInt)
        >> sequence


calculateChecksum : List Int -> Bool
calculateChecksum =
    let
        indexMult : Int -> Int
        indexMult =
            modBy 2 >> (+) 1
    in
    List.reverse
        >> List.indexedMap (\i x -> indexMult i * x)
        >> List.map
            (\x ->
                if x > 9 then
                    x - 9

                else
                    x
            )
        >> List.sum
        >> modBy 10
        >> (==) 0


validChecksum : String -> Maybe ()
validChecksum =
    toListOfDigits
        >> Maybe.map
            calculateChecksum
        >> Maybe.andThen boolMaybe


verify : List (a -> Maybe ()) -> a -> Maybe ()
verify validators x =
    case validators of
        [] ->
            Just ()

        validator :: vs ->
            Maybe.andThen (\_ -> verify vs x) (validator x)


valid : String -> Bool
valid =
    let
        validators : List (String -> Maybe ())
        validators =
            [ validLength, validChars, validChecksum ]
    in
    verify validators
        >> isJust
