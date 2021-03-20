module Wordy exposing (answer)

import Parser exposing ((|.), (|=), Parser, int, keyword, oneOf, run, spaces, succeed, symbol)


type Operator
    = Addition
    | Subtraction
    | Multiplication
    | Division
    | Exponent


type alias RTLAlgebraicStatement =
    { x : Int
    , operation : Operator
    , y : RTLStatementValue
    }


type RTLStatementValue
    = RTLStatement RTLAlgebraicStatement
    | RTLNum Int


type alias AlgebraicStatement =
    { x : LTRStatementValue
    , operation : Operator
    , y : Int
    }


type LTRStatementValue
    = Num Int
    | Statement AlgebraicStatement


getNextY : RTLStatementValue -> Int
getNextY y =
    case y of
        RTLNum yNum ->
            yNum

        RTLStatement yNumStatement ->
            yNumStatement.x


invertStatement : RTLAlgebraicStatement -> AlgebraicStatement
invertStatement { x, operation, y } =
    case y of
        RTLNum yNum ->
            AlgebraicStatement (Num x) operation yNum

        RTLStatement yStatement ->
            let
                xStatement =
                    AlgebraicStatement (Num x) operation (getNextY y)
            in
            buildLTRStatement xStatement yStatement


buildLTRStatement : AlgebraicStatement -> RTLAlgebraicStatement -> AlgebraicStatement
buildLTRStatement ltr rtl =
    let
        newStatement =
            AlgebraicStatement (Statement ltr) rtl.operation
    in
    case rtl.y of
        RTLNum y ->
            newStatement y

        RTLStatement yStatement ->
            buildLTRStatement (newStatement <| getNextY rtl.y) yStatement


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
        , Parser.map (\_ -> Subtraction) <| keyword "minus"
        , Parser.map (\_ -> Multiplication) <| keyword "times"
        , Parser.map (\_ -> Multiplication) <| keyword "multiplied by"
        , Parser.map (\_ -> Division) <| keyword "divided by"
        ]


parseSubsequentValues : Int -> Parser RTLStatementValue
parseSubsequentValues x =
    oneOf
        [ Parser.map (\_ -> RTLNum x) (symbol "?")
        , succeed (\op y -> RTLStatement (RTLAlgebraicStatement x op y))
            |. spaces
            |= operationParser
            |. spaces
            |= Parser.lazy (\_ -> naryParser)
        ]


naryParser : Parser RTLStatementValue
naryParser =
    Parser.andThen parseSubsequentValues numParser


statementParser : Parser RTLStatementValue
statementParser =
    succeed identity
        |. keyword "What"
        |. spaces
        |. keyword "is"
        |. spaces
        |= naryParser


operatorSimplifiers : List (AlgebraicStatement -> LTRStatementValue)
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


simplify : List (AlgebraicStatement -> LTRStatementValue) -> AlgebraicStatement -> Maybe Int
simplify simps alg =
    case simps of
        [] ->
            Nothing

        simp :: otherSimps ->
            case Debug.log "simplified" <| simp alg of
                Num n ->
                    Debug.log "finished number" <| Just n

                Statement stmt ->
                    simplify otherSimps stmt


answer : String -> Maybe Int
answer problem =
    case run statementParser problem of
        Ok (RTLStatement stmt) ->
            stmt
                |> invertStatement
                |> Debug.log "inverted"
                |> simplify operatorSimplifiers

        Ok (RTLNum num) ->
            Just num

        _ ->
            Nothing


simplifyStatement : (Operator -> Bool) -> (Int -> Operator -> Int -> Int) -> AlgebraicStatement -> LTRStatementValue
simplifyStatement opPred resolveArithmetic alg =
    let
        opMatches =
            opPred alg.operation
    in
    case alg.x of
        Num xNum ->
            if opMatches then
                Num <| resolveArithmetic xNum alg.operation alg.y

            else
                Statement alg

        Statement xStatement ->
            if opMatches then
                Statement
                    { xStatement
                        | y = resolveArithmetic xStatement.y alg.operation alg.y
                    }

            else
                Statement
                    { alg
                        | x = simplifyStatement opPred resolveArithmetic xStatement
                    }
