module Gigasecond exposing (add)

import Time


gigasecond : Int
gigasecond =
    1000000000


add : Time.Posix -> Time.Posix
add =
    Time.posixToMillis
        >> (+) (1000 * gigasecond)
        >> Time.millisToPosix
