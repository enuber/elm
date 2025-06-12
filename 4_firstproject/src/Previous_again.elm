module Previous_again exposing (main)
import Browser
import Html exposing ( div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)
import String exposing (length, fromInt, toInt)

-- the blue lines though program works, means that we need to add in types. (like TS)
initModel : Model
initModel = {  
    message = "Welcome" 
    , firstname = ""
    , age = 0
  }

-- inside the sandbox you send the initial content of the data, also what are the views and updates
-- a sandbox is a way to use and control an area of a web page
main : Program () Model Msg
main = Browser.sandbox {
  init = initModel
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
  | MsgNewAgeAsString String
  
-- creates a type for a reocrd which holds information about different types of values like strings and numbers
-- Model - traditional nmae, called so becasue it is the basis for modelling the logic that we are using
-- this is a template for having a message and a firstname 
type alias Model =
    { message : String
    , firstname : String
    , age: Int
    }

-- this paints the information
-- when setting up onClick or any events remember to import them at the top of page
-- we updated this from data to model as that is what we are receiving
-- for the type annotation, again, the view is the Model and it is producing Html and, the Msg part is indicating that it isn't just producing Html but, it is producing it with some sort of events. 
-- fromInt makes an integer a string
view : Model -> Html.Html Msg
view model = 
  div [] [
    text model.message
    , input [ onInput MsgNewName, value model.firstname ] []
    , input [ onInput MsgNewAgeAsString, value (fromInt model.age) ] []
    , button [ onClick MsgSurprise ] [ text "Surprise"]
    , button [ onClick MsgReset ] [ text "Reset"]
    -- we are importing String up above but can do String.fromInt or String.length
    , text (fromInt (length model.firstname))
  ]

-- update receives a message a signal of what is taking place
-- this is where you describe what is happening to make updates such as events. In this case we set up what happens for the click handlers. Notice that indentation matters.
update : Msg -> Model -> Model
update msg model = 
  case msg of 
    MsgSurprise -> 
      -- we removed the firstname = model.firstname by just adding model | this means we are only changing the message and the rest of what is in the model will stay the same
      {
        model | message ="Happy Birthday " ++ model.firstname ++ " !!!! You are " ++ (fromInt model.age)++ " years old."
      }

    MsgReset ->
      initModel

    MsgNewName newName ->
    -- same here, we removed the message as model will keep it and just update the firstname
      {
        model | firstname = newName
      }

    MsgNewAgeAsString newAge ->
      case toInt newAge of
          Just anInt ->
            {
              model | age = anInt
            }
          Nothing -> 
            {
              model | message = "The age is wrong ", age = 0
            }