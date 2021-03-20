module Triangle exposing (Triangle(..), triangleKind)


type Triangle
    = Equilateral
    | Isosceles
    | Scalene


toTriple : List number -> ( number, number, number )
toTriple lengths =
    case lengths |> List.sort of
        x :: y :: z :: _ ->
            ( x, y, z )

        _ ->
            ( 0, 0, 0 )


validTriangleLengths : List number -> Bool
validTriangleLengths lens =
    case lens of
        x :: y :: z :: _ ->
            x + y >= z && y + z >= x && x + z >= y

        _ ->
            False


validator : ( a -> Bool, String ) -> a -> Result String a
validator valTupl xs =
    if Tuple.first valTupl xs then
        Ok xs

    else
        Err (Tuple.second valTupl)


isValidTriangle : List number -> Result String (List number)
isValidTriangle tri =
    let
        someNonZero =
            ( List.any ((/=) 0), "Invalid lengths" )

        allPositive =
            ( List.all ((<=) 0), "Invalid lengths" )

        lengthEqualities =
            ( validTriangleLengths, "Violates inequality" )

        validations =
            List.map validator [ someNonZero, allPositive, lengthEqualities ]
    in
    List.foldl Result.andThen (Ok tri) validations


isEqualateral : ( number, number, number ) -> Bool
isEqualateral lens =
    case lens of
        ( a, b, c ) ->
            a == b && b == c


isIsosceles : ( number, number, number ) -> Bool
isIsosceles lens =
    case lens of
        ( a, b, c ) ->
            (a == b || b == c || c == a) && not (a == b && b == c)


isScaline : ( number, number, number ) -> Bool
isScaline lens =
    case lens of
        ( a, b, c ) ->
            a /= b && b /= c && c /= a


triangleTypeAssignment : ( number, number, number ) -> Triangle
triangleTypeAssignment tri =
    if isEqualateral tri then
        Equilateral

    else if isIsosceles tri then
        Isosceles

    else
        Scalene


triangleKind : number -> number -> number -> Result String Triangle
triangleKind x y z =
    [ x, y, z ]
        |> isValidTriangle
        |> Result.map toTriple
        |> Result.map triangleTypeAssignment
