module RobotSimulator exposing
    ( Bearing(..)
    , Robot
    , advance
    , defaultRobot
    , simulate
    , turnLeft
    , turnRight
    )


type Bearing
    = North
    | East
    | South
    | West


type alias Robot =
    { bearing : Bearing
    , coordinates : { x : Int, y : Int }
    }


defaultRobot : Robot
defaultRobot =
    { bearing = North
    , coordinates = { x = 0, y = 0 }
    }


turnRight : Robot -> Robot
turnRight robot =
    { robot
        | bearing =
            case robot.bearing of
                North ->
                    East

                East ->
                    South

                South ->
                    West

                West ->
                    North
    }


turnLeft : Robot -> Robot
turnLeft robot =
    { robot
        | bearing =
            case robot.bearing of
                North ->
                    West

                East ->
                    North

                South ->
                    East

                West ->
                    South
    }


advance : Robot -> Robot
advance robot =
    let
        { x, y } =
            robot.coordinates

        coords =
            robot.coordinates
    in
    { robot
        | coordinates =
            case .bearing robot of
                North ->
                    { coords
                        | y = (+) 1 <| y
                    }

                South ->
                    { coords
                        | y = (+) -1 <| y
                    }

                East ->
                    { coords
                        | x = (+) 1 <| x
                    }

                West ->
                    { coords
                        | x = (+) -1 <| x
                    }
    }


toAction : Char -> (Robot -> Robot)
toAction x =
    case x of
        'R' ->
            turnRight

        'L' ->
            turnLeft

        'A' ->
            advance

        _ ->
            advance


performAction : (Robot -> Robot) -> Robot -> Robot
performAction action =
    action


simulate : String -> Robot -> Robot
simulate directions robot =
    String.toList directions
        |> List.map toAction
        |> List.foldl performAction robot
