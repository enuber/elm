module Main exposing (main)
import Browser
import Html exposing ( div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)
import String exposing (length, fromInt, toInt)

-- Your starting values.
-- Nothing is used to indicate that firstname and age are empty/unset at first.
initModel : Model
initModel = {  
    message = "Welcome" 
    , firstname = Nothing
    , age = Nothing
  }

-- Browser.sandbox is a simple way to manage state and events on the page.
-- You provide it with:
-- init: the starting Model
-- view: a function that turns the model into HTML
-- update: a function that reacts to Msg events and returns a new model
main : Program () Model Msg
main = Browser.sandbox {
  init = initModel
  , view = view
  , update = update
 }
 

-- Msg represents user interactions/events.
-- MsgNewName String means the message carries a string input value (from the user).
type Msg = MsgSurprise
  | MsgReset
  | MsgNewName String
  | MsgNewAgeAsString String
  
-- Model holds your application state.
-- Maybe types are used so values can either exist (Just something) or not (Nothing).
-- This avoids needing to initialize fields with empty strings or default numbers.
type alias Model =
    { message : String
    , firstname : Maybe String
    , age: Maybe Int
    }

-- this paints the information
-- when setting up onClick or any events remember to import them at the top of page
-- we updated this from data to model as that is what we are receiving
-- for the type annotation, again, the view is the Model and it is producing Html and, the Msg part is indicating that it isn't just producing Html but, it is producing it with some sort of events. 
-- fromInt makes an integer a string
-- by adding maybe to the Model above, we now need to add in a default, this way we don't get an error if no name exists. 
view : Model -> Html.Html Msg
view model = 
  div [] [
    viewMessage model.message
    , viewFistnameInput model.firstname
    , viewAgeInput model.age
    , viewSurpriseBtn
    , viewResetBtn
    , viewLength model.firstname
  ]

-- rather than pass in the whole model, we are removing model = text model.message and just using the part we need. We also have to declare the type in the first line which in this case is just a
viewMessage : String -> Html.Html msg
viewMessage message = text message

--Maybe.withDefault "" is used so the input doesn’t break if firstname = Nothing.
viewFistnameInput : Maybe String -> Html.Html Msg
viewFistnameInput firstname = input [ onInput MsgNewName, value (Maybe.withDefault "" firstname) ] []

viewAgeInput : Maybe Int -> Html.Html Msg
viewAgeInput age = input [ onInput MsgNewAgeAsString, value (fromInt (Maybe.withDefault 0 age)) ] []

viewSurpriseBtn : Html.Html Msg
viewSurpriseBtn = button [ onClick MsgSurprise ] [ text "Surprise"]

viewResetBtn : Html.Html Msg
viewResetBtn = button [ onClick MsgReset ] [ text "Reset"]

viewLength :  Maybe String -> Html.Html msg
    -- we are importing String up above but can do String.fromInt or String.length
viewLength firstname = text (fromInt (length (Maybe.withDefault "" firstname)))

-- MsgSurprise handles conditional logic based on whether the inputs are present.
-- MsgReset resets everything using initModel.
-- MsgNewName trims the input and updates the model.
-- MsgNewAgeAsString tries to parse the string into an Int, updates state, or shows an error.
update : Msg -> Model -> Model
update msg model = 
  case msg of 
    MsgSurprise -> 
      case model.age of 
        Just anAge ->
          case model.firstname of 
            Just aName ->
            -- we removed the firstname = model.firstname by just adding model | this means we are only changing the message and the rest of what is in the model will stay the same
              {
                model | message ="Happy Birthday " ++ aName ++ " !!!! You are " ++ (fromInt anAge)++ " years old."
              }
            Nothing ->
              { model | message = "The first name is required"}
        Nothing ->
         { model | message = "The age is required" }
    MsgReset ->
      initModel

    MsgNewName newName ->
      if (String.trim newName) == "" then 
        {
          model | firstname = Nothing
        }
      else
      -- same here, we removed the message as model will keep it and just update the firstname
        { model | firstname = Just newName }

    MsgNewAgeAsString newAge ->
      case toInt newAge of
          Just anInt ->
             { model | age = Just anInt }

          Nothing -> 
            { model | message = "The age is wrong", age = Nothing }
            