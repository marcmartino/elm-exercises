module AtbashCipher exposing (decode, encode, splitList)

import Regex


invertAlpha : Char -> Char
invertAlpha l =
    let
        flippedChar =
            Char.toLower
                >> Char.toCode
                >> (+) -122
                >> abs
                >> (+) 97
                >> Char.fromCode
    in
    if Char.isAlpha l then
        flippedChar l

    else
        l


sanitizeEncodedText : String -> String
sanitizeEncodedText =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromString "[^\\d\\w]"
    in
    Regex.replace regex (always "")


sanitizeUnencodedText : String -> String
sanitizeUnencodedText =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromString "[^\\d\\w]"
    in
    Regex.replace regex (always "")


splitList : Int -> List a -> ( List a, List a )
splitList count list =
    case ( count, list ) of
        ( 0, xs ) ->
            ( [], xs )

        ( _, [] ) ->
            ( [], [] )

        ( n, x :: xs ) ->
            let
                furtherSplit =
                    splitList (n - 1) xs
            in
            ( x :: Tuple.first furtherSplit, Tuple.second furtherSplit )


groupList : Int -> List a -> List (List a)
groupList n list =
    case splitList n list of
        ( group, [] ) ->
            [ group ]

        ( group, rest ) ->
            group :: groupList n rest


encode : String -> String
encode =
    sanitizeUnencodedText
        >> String.trim
        >> String.toList
        >> List.map invertAlpha
        >> groupList 5
        >> List.map String.fromList
        >> String.join " "


decode : String -> String
decode =
    sanitizeEncodedText
        >> String.trim
        >> String.toList
        >> List.map invertAlpha
        >> String.fromList
