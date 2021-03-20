module Anagram exposing (detect)


sortWord : String -> String
sortWord =
    String.fromList << sort << String.toList


sort : List comparable -> List comparable
sort list =
    case list of
        x :: xs ->
            let
                low =
                    List.filter ((>) x) xs

                high =
                    List.filter ((<=) x) xs
            in
            sort low ++ (x :: sort high)

        [] ->
            []


notTheSameAs : String -> String -> Bool
notTheSameAs word =
    (/=) (String.toLower word) << String.toLower


detect : String -> List String -> List String
detect word =
    let
        sortedWord =
            sortWord <| String.toLower <| word
    in
    List.filter
        ((==) sortedWord
            << sortWord
            << String.toLower
        )
        << List.filter (notTheSameAs word)
