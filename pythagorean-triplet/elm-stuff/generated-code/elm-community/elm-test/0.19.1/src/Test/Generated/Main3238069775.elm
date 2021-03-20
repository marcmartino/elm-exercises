module Test.Generated.Main3238069775 exposing (main)

import Tests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Tests" [Tests.tests] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 82543825960604, processes = 8, paths = ["/home/marmar/exercism/elm/pythagorean-triplet/tests/Tests.elm"]}