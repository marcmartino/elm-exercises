module ListOps exposing
    ( append
    , concat
    , filter
    , foldl
    , foldr
    , length
    , map
    , reverse
    )

length : List a -> Int
length list =
    case list  of
        _ :: rest ->
            1 + length rest
        [] -> 
            0


reverse : List a -> List a
reverse list =
    case list of
        x :: xs ->
            (reverse xs) ++ [x]

        [] ->
            []


foldl : (a -> b -> b) -> b -> List a -> b
foldl f acc list =
    case list of
        x :: xs ->
            foldl f (f x acc) xs

        [] -> acc       


foldr : (a -> b -> b) -> b -> List a -> b
foldr f acc =
    reverse 
        >> foldl f acc


map : (a -> b) -> List a -> List b
map f list =
    case list of
        x :: xs ->
            (f x) :: (map f xs)
        [] -> []


filter : (a -> Bool) -> List a -> List a
filter f list =
    case list of
        x :: xs ->
            if f x == True then
                x :: filter f xs
            else
                filter f xs

        [] -> []

appendRec : List a -> List a -> List a
appendRec listA listB =
    case listA of
        a :: otherA ->
            appendRec otherA (a :: listB)

        [] ->
            listB

append : List a -> List a -> List a
append xs =
    appendRec (reverse xs)


concat : List (List a) -> List a
concat =
    foldr (++) []
