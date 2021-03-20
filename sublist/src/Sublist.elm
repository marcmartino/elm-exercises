module Sublist exposing (ListComparison(..), sublist)


type ListComparison
    = Equal
    | Superlist
    | Sublist
    | Unequal


isPrefixOf : Bool -> List a -> List a -> Bool
isPrefixOf isPrefix xList yList =
    case ( isPrefix, xList, yList ) of
        ( False, _, _ ) ->
            False

        ( _, [], _ ) ->
            True

        ( _, _, [] ) ->
            False

        ( _, x :: xs, y :: ys ) ->
            isPrefixOf (x == y) xs ys


isSublist : List a -> List a -> Bool
isSublist =
    isSublistRec False


isSublistRec : Bool -> List a -> List a -> Bool
isSublistRec sublistFound xList yList =
    case ( sublistFound, xList, yList ) of
        ( True, _, _ ) ->
            True

        ( _, [], [] ) ->
            True

        ( _, _, [] ) ->
            False

        ( _, xs, y :: ys ) ->
            isSublistRec (isPrefixOf True xs (y :: ys)) xs ys


sublist : List a -> List a -> ListComparison
sublist xs ys =
    let
        sublistChecks : ( Bool, Bool )
        sublistChecks =
            ( isSublist xs ys, isSublist ys xs )
    in
    case sublistChecks of
        ( True, True ) ->
            Equal

        ( True, False ) ->
            Sublist

        ( False, True ) ->
            Superlist

        ( False, False ) ->
            Unequal
