module Main exposing (main)
import Chart as C
import Chart.Attributes as CA
import Svg
import Dict exposing (Dict)
import Html exposing (Html)


main : Html msg
main = 
  C.chart
    [ CA.width 900
      , CA.height 300
      , CA.margin {top = 50, right = 50, bottom = 50, left = 50}
    ] 
    [
      C.bars [] [
        C.bar .calories [ CA.color "purple"],
        C.bar .kj [ CA.color "pink"]
      ]
      data
      , C.xLabels [ CA.format labelFor ]
      , C.yLabels [ CA.withGrid ]
      , C.labelAt CA.middle .max [ 
        CA.moveUp 20
        , CA.fontSize 24
        ] [ Svg.text "Fruits"]
    ]

data : List { x : number, calories : Float, kj : Float }
data = [
  { x = 1, calories = 52.0, kj = 218.0 }
  , { x = 2, calories = 160.0, kj = 672.0 }
  , { x = 3, calories = 47.0, kj = 197.0 }
  , { x = 4, calories = 88.0, kj = 478.0 }
  ]

labels : Dict number String
labels = Dict.fromList [
  (1, "Apple"),
  (2, "Avocado"),
  (3, "Clementine"),
  (4, "Grape")
  ]
  
labelFor : number -> String
labelFor x = 
  case Dict.get x labels of 
    Just label -> 
      label
    Nothing -> 
      ""

-- labelFor x =
--    Maybe.withDefault "" (Dict.get x labels)

-- labelFor x =
--   if x == 1 then  
--     "Apple"
--   else if x == 2 then
--     "Avocado"
--   else if x == 3 then
--     "Clementine"
--   else if x == 4 then
--     "Grape"
--   else  
--     ""