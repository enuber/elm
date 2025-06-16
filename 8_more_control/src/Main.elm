port module Main exposing (main)
import Browser
import Html
import Html.Events exposing (onClick)

-- note - using document. 
main : Program Int Model Msg
main = Browser.document {
    init = init
    , view = view 
    , update = update
    , subscriptions = subscriptions
  }

type alias Model =
    { 
      title : String
      , counter : Int
    }

initModel : Int -> Model
initModel flags = 
  {
    title = "My title"
    , counter = flags
  }

type Msg = 
  MsgIncreaseCounter

init : Int -> ( Model, Cmd msg )
init flags = 
  ( initModel flags, Cmd.none)

view: Model -> Browser.Document Msg
view model = 
  {
    title = model.title
    , body = [ Html.button [onClick MsgIncreaseCounter] 
      [
        Html.text ("Counter " 
        ++ String.fromInt model.counter)
      ]]
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MsgIncreaseCounter ->
      let
        newCounter = model.counter +1 
        newTitle = "Title " ++ String.fromInt newCounter
        newModel = { model | counter = newCounter, title = newTitle}
      in
      (newModel, persistCounter newCounter)


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none

port persistCounter : Int -> Cmd msg
