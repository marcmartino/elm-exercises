module Wordy exposing (answer)

import Parser exposing ((|.), (|=), Parser, int, keyword, oneOf, run, spaces, succeed, symbol)


type Operator
    = Addition
    | Subtraction
    | Multiplication
    | Division
    | Exponent


type alias AlgebraicStatement =
    { x : Int
    , operation : Operator
    , y : StatementValue
    }


type StatementValue
    = Statement AlgebraicStatement
    | Num Int


numParser : Parser Int
numParser =
    oneOf
        [ succeed negate
            |. symbol "-"
            |= int
        , int
        ]


operationParser : Parser Operator
operationParser =
    oneOf
        [ Parser.map (\_ -> Addition) <| keyword "plus"
        , Parser.map (\_ -> Addition) <| keyword "+"
        , Parser.map (\_ -> Subtraction) <| keyword "minus"
        , Parser.map (\_ -> Subtraction) <| keyword "-"
        , Parser.map (\_ -> Multiplication) <| keyword "times"
        , Parser.map (\_ -> Multiplication) <| keyword "*"
        , Parser.map (\_ -> Multiplication) <| keyword "multiplied by"
        , Parser.map (\_ -> Division) <| keyword "divided by"
        , Parser.map (\_ -> Division) <| keyword "/"
        ]


parseSubsequentValues : Int -> Parser StatementValue
parseSubsequentValues x =
    oneOf
        [ Parser.map (\_ -> Num x) (symbol "?")
        , succeed (\op y -> Statement (AlgebraicStatement x op y))
            |. spaces
            |= operationParser
            |. spaces
            |= Parser.lazy (\_ -> naryParser)
        ]


naryParser : Parser StatementValue
naryParser =
    Parser.andThen parseSubsequentValues numParser


statementParser : Parser StatementValue
statementParser =
    succeed identity
        |. keyword "What"
        |. spaces
        |. keyword "is"
        |. spaces
        |= naryParser


operatorSimplifiers : List (AlgebraicStatement -> StatementValue)
operatorSimplifiers =
    [ simplifyStatement (\op -> op == Exponent) (\x _ y -> x ^ y)
    , simplifyStatement (\op -> op == Multiplication || op == Division)
        (\x op y ->
            case op of
                Multiplication ->
                    x * y

                Division ->
                    x // y

                _ ->
                    -1
        )
    , simplifyStatement (\op -> op == Addition || op == Subtraction)
        (\x op y ->
            case op of
                Addition ->
                    x + y

                Subtraction ->
                    x - y

                _ ->
                    -1
        )
    ]


simplify : List (AlgebraicStatement -> StatementValue) -> AlgebraicStatement -> Maybe Int
simplify simps alg =
    case simps of
        [] ->
            Nothing

        simp :: otherSimps ->
            case simp alg of
                Num n ->
                    Just n

                Statement stmt ->
                    simplify otherSimps stmt


answer : String -> Maybe Int
answer problem =
    case run statementParser problem of
        Ok (Statement stmt) ->
            stmt
                |> simplify operatorSimplifiers

        Ok (Num num) ->
            Just num

        _ ->
            Nothing


simplifyStatement : (Operator -> Bool) -> (Int -> Operator -> Int -> Int) -> AlgebraicStatement -> StatementValue
simplifyStatement opPred resolveArithmetic alg =
    let
        opMatches =
            opPred alg.operation
    in
    case alg.y of
        Num yNum ->
            if opMatches then
                Num <| resolveArithmetic alg.x alg.operation yNum

            else
                Statement alg

        Statement yStatement ->
            if opMatches then
                simplifyStatement opPred
                    resolveArithmetic
                    { yStatement
                        | x = resolveArithmetic alg.x alg.operation yStatement.x
                    }

            else
                Statement
                    { alg
                        | y = simplifyStatement opPred resolveArithmetic yStatement
                    }
