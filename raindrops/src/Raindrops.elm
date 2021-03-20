module Raindrops exposing (raindrops)


type alias DropCondition =
    ( Int -> Bool, String )


divisibleBy : Int -> Int -> Bool
divisibleBy divisor =
    modBy divisor
        >> (==) 0


dropTests : List DropCondition
dropTests =
    [ ( divisibleBy 3, "Pling" ), ( divisibleBy 5, "Plang" ), ( divisibleBy 7, "Plong" ) ]


testDrop : Int -> DropCondition -> Maybe String
testDrop n dropCondition =
    if Tuple.first dropCondition n then
        Just <| Tuple.second dropCondition

    else
        Nothing


filterNothing : List (Maybe a) -> List a
filterNothing list =
    case list of
        (Just x) :: xs ->
            x :: filterNothing xs

        Nothing :: xs ->
            filterNothing xs

        [] ->
            []


defaultList : List a -> List a -> List a
defaultList default list =
    case list of
        [] ->
            default

        _ ->
            list


raindrops : Int -> String
raindrops number =
    List.map (testDrop number) dropTests
        |> filterNothing
        |> defaultList [ String.fromInt number ]
        |> String.join ""
