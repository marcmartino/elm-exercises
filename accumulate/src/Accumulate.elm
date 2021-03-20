module Accumulate exposing (accumulate)


accumulate : (a -> b) -> List a -> List b
accumulate func =
    tailAccum [] func << List.reverse


tailAccum : List b -> (a -> b) -> List a -> List b
tailAccum acc fn input =
    case input of
        [] ->
            acc

        x :: xs ->
            tailAccum (fn x :: acc) fn xs
