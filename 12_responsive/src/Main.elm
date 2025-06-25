module Main exposing (main)
import Browser
import Html
import Element exposing (..)
import Element.Font as EF
import Browser.Events

main: Program Flags Model Msg
main =  Browser.element
  {
    init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
  }

type alias Size =
  {
    w: Int
    , h: Int
  }

type alias Model = 
  {
    windowSize : Size
  }

type Msg =
      MsgWindowSizeChanged Int Int

type alias Flags = Size


init : Flags -> ( Model, Cmd msg )
init flags =
  (initModel flags, Cmd.none)

initModel : Flags -> Model
initModel flags = {
    windowSize = flags
  }

view : Model -> Html.Html Msg
view model = 
  let
    direction = if model.windowSize.w > 800 then
        row
      else 
        column
    fontSize = if model.windowSize.w > 1024 then
        18
      else if model.windowSize.w > 800 then
        20
      else
        22
  in  
  layout [] 
    ( Element.column[ EF.size fontSize][
      direction [ spacing 10 ] [
        text (String.fromInt model.windowSize.w ++
        "x" ++ String.fromInt model.windowSize.h)
        , text "Item A"
        , text "Item B"
        , text "Item C"
        , text "Item D"
        , text "Item E"
      ]
        , viewWrappedRow
    ]
  )

viewWrappedRow =
  wrappedRow [ spacing 10] [
    text "Wrapped 1"
    , text "Wrapped 2"
    , text "Wrapped 3"
    , text "Wrapped 4"
    , text "Wrapped 5"
    , text "Wrapped 6"
    , text "Wrapped 7"
    , text "Wrapped 8"
    , text "Wrapped 9"
    , text "Wrapped 10"
  ]
  
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of 
     MsgWindowSizeChanged w h ->
      let
        newWindowSize = {
            w = w
            , h = h
          }
      in
        ({model | windowSize = newWindowSize}, Cmd.none)


 
subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onResize MsgWindowSizeChanged