module TwelveDays exposing (recite)

import Array exposing (Array)
import Maybe exposing (Maybe)


christmasGifts : Array String
christmasGifts =
    Array.fromList
        [ "a Partridge in a Pear Tree"
        , "two Turtle Doves"
        , "three French Hens"
        , "four Calling Birds"
        , "five Gold Rings"
        , "six Geese-a-Laying"
        , "seven Swans-a-Swimming"
        , "eight Maids-a-Milking"
        , "nine Ladies Dancing"
        , "ten Lords-a-Leaping"
        , "eleven Pipers Piping"
        , "twelve Drummers Drumming"
        ]


ordinals : Array String
ordinals =
    Array.fromList
        [ "first"
        , "second"
        , "third"
        , "fourth"
        , "fifth"
        , "sixth"
        , "seventh"
        , "eighth"
        , "ninth"
        , "tenth"
        , "eleventh"
        , "twelfth"
        ]


lineLyrics : String -> String -> String
lineLyrics dayName gifts =
    String.concat
        [ "On the "
        , dayName
        , " day of Christmas my true love gave to me: "
        , gifts
        , "."
        ]


nthOfArray : Array String -> Int -> String
nthOfArray arr i =
    Maybe.withDefault "" (Array.get i arr)


christmasGiftByNumber : Int -> String
christmasGiftByNumber =
    nthOfArray christmasGifts


daySpellingByNumber : Int -> String
daySpellingByNumber =
    nthOfArray ordinals


concatLastGiftAnd : List String -> List String
concatLastGiftAnd gifts =
    case gifts of
        [] ->
            []

        [ g ] ->
            [ g ]

        g :: [ last ] ->
            [ g, "and " ++ last ]

        g :: gs ->
            g :: concatLastGiftAnd gs


songLine : Int -> String
songLine x =
    (lineLyrics (daySpellingByNumber x) << String.join ", " << concatLastGiftAnd << List.map christmasGiftByNumber << List.reverse << List.range 0) x


recite : Int -> Int -> List String
recite start end =
    let
        songDayNums =
            List.range (Basics.max 1 start - 1) (Basics.min 12 end - 1)
    in
    List.map songLine songDayNums
