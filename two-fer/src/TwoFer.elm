module TwoFer exposing (twoFer)

twoFer : Maybe String -> String
twoFer name =
    case name of
        Nothing ->
            "One for you, one for me."

        Just you ->
            String.concat ["One for ", you, ", one for me."]
    
