module Allergies exposing (Allergy(..), allergensList, isAllergicTo, toList)

import Bitwise exposing (and)


type Allergy
    = Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats


type alias AllergenList =
    List ( Allergy, Int )


alls : List Allergy
alls =
    [ Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats ]


allergensList : AllergenList
allergensList =
    alls
        |> List.indexedMap Tuple.pair
        |> List.reverse
        |> List.map (\( i, all ) -> ( all, 2 ^ i ))


findAllergen : AllergenList -> Allergy -> Int
findAllergen list allergy =
    case list of
        [] ->
            0

        ( all, val ) :: xs ->
            if all == allergy then
                val

            else
                findAllergen xs allergy


allergensByName : Allergy -> Int
allergensByName =
    findAllergen allergensList


checkAllergyScore : Int -> Int -> Bool
checkAllergyScore testScore =
    and testScore
        >> (/=) 0


isAllergicTo : Allergy -> Int -> Bool
isAllergicTo allergy score =
    allergensByName allergy
        |> checkAllergyScore score


toListRec : AllergenList -> Int -> List Allergy
toListRec allList score =
    case allList of
        [] ->
            []

        ( allergen, allergenValue ) :: otherAlls ->
            if checkAllergyScore score allergenValue then
                allergen :: toListRec otherAlls score

            else
                toListRec otherAlls score


toList : Int -> List Allergy
toList score =
    toListRec allergensList score
