module Home exposing (..)
import Element exposing (..)
import Element.Font as EF
import Element.Input as Input

type Msg = 
  MsgDummy

type alias Model =
    { 
      counter: Int
    }

initModel : Model
initModel = {
    counter = 0
  }

-- node by exposing all above, don't have to do Element.column...etc
view: Model -> Element msg
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
  ]
  
update : Msg -> Model -> (Model, Cmd.Cmd Msg)
update msg model =
    case msg of
        MsgDummy ->
          (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none