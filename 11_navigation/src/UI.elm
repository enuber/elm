module UI exposing (..)
import Element exposing (..)
import Element.Font as EF
import Element.Input as Input

link : List (Element.Attribute msg) -> String -> String -> Element msg
link attrs url caption = 
    Element.link 
    ([ EF.color (Element.rgb255 0x11 0x55 0xFF)
    , EF.underline
    ] ++ attrs) {
      url = url
      , label = Element.text caption
    }

linkWithAction : List (Element.Attribute msg) -> msg -> String -> Element msg
linkWithAction attrs msg caption = 
  Input.button 
  ([ EF.color (Element.rgb255 0x11 0x55 0xFF)
    , EF.underline
    ] ++ attrs)
    {
      onPress = Just msg
      , label = text caption
    }