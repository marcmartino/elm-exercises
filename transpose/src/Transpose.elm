module Transpose exposing (transpose)

import String


firstChars : List (List Char) -> Maybe String
firstChars chars =
    let
        headStr =
            List.foldl charAccum "" <| List.map List.head <| chars
    in
    case headStr of
        "" ->
            Nothing

        _ ->
            Just headStr


trimEndSpaces : String -> String
trimEndSpaces str =
    case String.trimRight str of
        "" ->
            str

        trimmed ->
            trimmed


charAccum : Maybe Char -> String -> String
charAccum char str =
    case char of
        Just c ->
            str ++ String.fromChar c

        _ ->
            str ++ " "


transposedList : List (List Char) -> List String
transposedList list =
    let
        headString =
            trimEndSpaces <|
                List.foldl charAccum "" <|
                    List.map List.head <|
                        list

        rest =
            List.map (Maybe.withDefault [] << List.tail) list

        restCount =
            List.sum <| List.map List.length <| rest
    in
    case ( restCount, headString ) of
        ( 0, "" ) ->
            []

        ( 0, _ ) ->
            [ headString ]

        _ ->
            headString :: transposedList rest


transpose : List String -> List String
transpose =
    transposedList << List.map String.toList
