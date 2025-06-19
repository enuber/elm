module MyFirstTest exposing (suite)

import Test exposing (Test, describe, test, fuzz)
import Expect
import Fuzz exposing (int)
import Main


testAdd : Test
testAdd =
    test "1 + 1 should be 2" <|
        \_ ->
            Expect.equal 2 (1 + 1)


testShrinkNoChange : Test
testShrinkNoChange =
    test "shrink text should do nothing when text is short enough" <|
        \_ ->
            let
                result = Main.shrinkText 20 "This is a test"
            in
            Expect.equal "This is a test" result


testShrinkShortens : Test
testShrinkShortens =
    test "shrink text should shrink when text is too long" <|
        \_ ->
            let
                result = Main.shrinkText 5 "This is a test"
            in
            Expect.equal "This  ..." result


testNPlusZero : Test
testNPlusZero =
    fuzz int "n + 0 should always be n" <|
        \n ->
            Expect.equal n (n + 0)


testNGreater : Test
testNGreater =
    fuzz (Fuzz.intRange 1 1000) "n + n is greater than n for positive n" <|
        \n ->
            Expect.equal True (n + n > n)


testRandomShrink : Test
testRandomShrink =
    fuzz Fuzz.string "shrinkText truncates fixed max length (5)" <|
        \str ->
            let
                result = Main.shrinkText 5 str
            in
            if String.length str > 5 then
                Expect.equal True (String.endsWith "..." result)
            else
                Expect.equal result str


testRandomShrinkIntString : Test
testRandomShrinkIntString =
    fuzz (Fuzz.map2 Tuple.pair Fuzz.string (Fuzz.intRange 0 100))
        "shrinkText truncates dynamic max length" <|
        \(str, maxLen) ->
            let
                result = Main.shrinkText maxLen str
            in
            if String.length str > maxLen then
                Expect.equal True (String.endsWith "..." result)
            else
                Expect.equal result str


suite : Test
suite =
    describe "My first tests"
        [ testAdd
        , testShrinkNoChange
        , testShrinkShortens
        , testNPlusZero
        , testNGreater
        , testRandomShrink
        , testRandomShrinkIntString
        ]
