module Acronym exposing (abbreviate)

import Maybe
import String


abbreviate : String -> String
abbreviate =
    String.split " "
        >> List.concatMap (String.split "-")
        >> List.map (String.toList >> List.head >> Maybe.withDefault ' ')
        >> String.fromList
        >> String.toUpper
