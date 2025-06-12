module Previous exposing (main)
import Browser
import Html exposing ( div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)

-- inside the sandbox you send the initial content of the data, also what are the views and updates
-- a sandbox is a way to use and control an area of a web page
main = Browser.sandbox {
  init = {
    message = "Welcome" 
    , firstname = ""
  }
  , view = view
  , update = update
 }

-- this is preparing the code to be able to recognize which click will be doing what.
-- Msg can be anything but it is convention to call it this.
-- this "type" is used for signals, ie events
-- for MsgNewName it isn't a generic signal like not an event, it receives a value as a string so needs to say what it is to receive
type Msg = MsgSurprise
  | MsgReset
  | MsgNewName String
  
-- creates a type for a reocrd which holds information about different types of values like strings and numbers
-- Model - traditional nmae, called so becasue it is the basis for modelling the logic that we are using
-- this is a template for having a message and a firstname 
type alias Model =
    { message : String
    , firstname : String
    }

-- this paints the information
-- when setting up onClick or any events remember to import them at the top of page
-- we updated this from data to model as that is what we are receiving
view model = 
  div [] [
    text model.message
    , input [ onInput MsgNewName, value model.firstname ] []
    , button [ onClick MsgSurprise ] [ text "Surprise"]
    , button [ onClick MsgReset ] [ text "Reset"]
  ]

-- update receives a message a signal of what is taking place
-- this is where you describe what is happening to make updates such as events. In this case we set up what happens for the click handlers. Notice that indentation matters.
update msg model = 
  case msg of 
    MsgSurprise -> 
      {
        message ="Happy Birthday " ++ model.firstname ++ " !!!!"
        , firstname = model.firstname
      }

    MsgReset ->
      {
        message ="Welcome "
        , firstname = ""
      }

    MsgNewName newName ->
      {
        message = model.message
        , firstname = newName
      }
