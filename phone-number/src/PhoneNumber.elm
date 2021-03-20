module PhoneNumber exposing (getNumber)

import Html exposing (a)
import Regex exposing (Regex)


isCorrectLength : Int -> Bool
isCorrectLength len =
    len == 10 || len == 11


onlyNumbers : String -> String
onlyNumbers =
    let
        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString <|
                    "[^0-9]"
    in
    Regex.replace regex (always "")


maybe : (a -> Bool) -> a -> Maybe a
maybe pred val =
    if pred val then
        Just val

    else
        Nothing


removeOne : String -> Maybe String
removeOne num =
    case ( String.toList num, String.length num ) of
        ( _, 10 ) ->
            Just num

        ( '1' :: restNum, 11 ) ->
            Just <| String.fromList restNum

        _ ->
            Nothing


isValidNumber : String -> Bool
isValidNumber =
    let
        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString <|
                    "[2-9]\\d{2}[2-9]\\d{6}"
    in
    (==) 1 << List.length << Regex.find regex


getNumber : String -> Maybe String
getNumber =
    Maybe.andThen (maybe isValidNumber)
        << Maybe.andThen removeOne
        << maybe (isCorrectLength << String.length)
        << onlyNumbers
