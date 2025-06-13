module Previous exposing (main)
import Http
import Json.Decode exposing (Decoder, field, string)
import Browser
import Html exposing (Html)

-- not using sandbox because you can't make a request with one
-- subscriptions is where you can send data from Elm to the browser (one of the things in Browser.element)
main: Program () Model Msg
main = Browser.element {
  init = init,
  view = view, 
  update = update, 
  subscriptions = subscriptions
  }

init : () -> (Model, Cmd Msg)
init _ =
    ( { title = "Loading...", error = Nothing }, getTitle )


view : Model -> Html Msg
view model =
  case model.error of
      Just error -> 
        Html.text (getErrorMessage error)

      Nothing ->
        Html.text model.title

-- Cmd.none just means we don't need anything else to happen, it is expected to have a Cmd msg
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MsgGotTitle (Ok newTitle) ->
            ( { model | title = newTitle }, Cmd.none )

        MsgGotTitle (Err errorDetail) ->
            ( { model | error = Just errorDetail }, Cmd.none )

getErrorMessage : Http.Error -> String
getErrorMessage errorDetail = 
  case errorDetail of
      Http.NetworkError ->
        "Connection error"
      Http.BadStatus errorStatus ->
        "Invalid server response " ++ String.fromInt errorStatus
      Http.Timeout ->
        "Request time out"
      Http.BadUrl reasonError ->
        "Invalid request URL " ++ reasonError
      Http.BadBody invalidData ->
        "Invalid data " ++ invalidData

-- we also don't need any subscription at this point but it is required for Browser.events
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

type alias Model =
    { title : String
      , error: Maybe Http.Error
    }

--
type Msg = 
  MsgGotTitle (Result Http.Error String)


-- the expect line is the way to make sure we know when the data arrives, remember that MSG is like events/waiting for a signal that something has happened. We are also telling it what to expect in this case JSON
getTitle : Cmd Msg
getTitle = 
  Http.get {
    url = "https://jsonplaceholder.typicode.com/posts/1"
    , expect = Http.expectJson MsgGotTitle dataTitleDecoder
  }

-- here we are saying that we need to decode this field that has a key of "title" and, it is a string
-- note that above I am exposing field and string so don't have to put Json.Decode.field
dataTitleDecoder : Decoder String
dataTitleDecoder =
    field "title" string