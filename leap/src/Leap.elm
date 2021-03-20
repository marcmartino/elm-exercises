module Leap exposing (isLeapYear)


divBy : Int -> Int -> Bool
divBy div =
    (==) 0 << modBy div


isLeapYear : Int -> Bool



-- isLeapYear year =
--     divBy 4 year && not (divBy 100 year) || (divBy 4 year && divBy 400 year)


isLeapYear year =
    List.all (\cond -> cond year) [ divBy 4, \x -> not (divBy 100 x) || divBy 400 x ]
