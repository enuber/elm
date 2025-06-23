module Home exposing (..)
import Element exposing (..)
import Element.Font as EF
import Element.Input as Input

type Msg = 
  MsgIncrementCounter

type alias Model =
    { 
      counter: Int
    }

initModel : Model
initModel = {
    counter = 0
  }

-- node by exposing all above, don't have to do Element.column...etc
view: Model -> Element Msg
view model = 
  column [ Element.padding 20 ]
  [
    text ("My Blog " ++ String.fromInt model.counter)
    , paragraph [ 
        paddingXY 0 20
        ,  EF.size 14
      ]
    [
      text "Welcome to my new mini blog made with Elm and Elm UI"
    ]
    , Input.button [] {
      onPress = Just MsgIncrementCounter
      , label = text "Count"
    }
  ]
  
update : Msg -> Model -> (Model, Cmd.Cmd Msg)
update msg model =
    case msg of
        MsgIncrementCounter ->
          ({model | counter = model.counter + 1}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none