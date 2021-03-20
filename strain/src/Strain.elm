module Strain exposing (discard, keep)


keep : (a -> Bool) -> List a -> List a
keep pred list =
    case list of
        x :: xs ->
            if pred x then
                x :: keep pred xs

            else
                keep pred xs

        [] ->
            []


discard : (a -> Bool) -> List a -> List a
discard predicate =
    keep (not << predicate)
