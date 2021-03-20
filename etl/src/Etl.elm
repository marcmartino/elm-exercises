module Etl exposing (transform)

import Dict exposing (Dict)

-- not sure exactly how to iterate over a dict
-- there may be some automated way or i might need to
-- use the fact that i know the keys are 1,2,3,4,5,8,10
-- i vaguely rememberi maybe be able to get a list of tuples
-- from the dict


matchLetterToPointValue : (Int, List String) -> List (String, Int)
matchLetterToPointValue (points, letters) =
    case letters of
        x :: xs ->
            (String.toLower x, points) :: matchLetterToPointValue (points, xs)
        
        [] -> []

-- looks essentially like a rewrite of Dict.fromList
collectLetters : (String, Int) -> Dict String Int -> Dict String Int
collectLetters (letter, pointValue) allLetters =
    Dict.insert letter pointValue allLetters

transform : Dict Int (List String) -> Dict String Int
transform =
    Dict.toList
        >> List.concatMap matchLetterToPointValue
        >> List.foldl collectLetters Dict.empty
    
