module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Url exposing (Url)
import Html exposing (Html, text)
import Browser exposing (Document, UrlRequest)
import Element exposing (..)
import Element.Font
import About
import Home

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


-- MODEL

type alias Model =
    { 
       url : Url
      , navigationKey : Nav.Key
      , modelAboutPage : About.Model
      , modelHomePage : Home.Model
    }


initModel : Url -> Nav.Key  -> Model
initModel url navigationKey =
    { 
       url = url
      , navigationKey = navigationKey
      , modelAboutPage = About.initModel
      , modelHomePage = Home.initModel
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navigationKey =
    ( initModel url navigationKey , Cmd.none )

-- VIEW

view : Model -> Document Msg
view model =
    { title = getTitle model.url
    , body = [ Element.layout [] (viewContent model) ]
    }

getTitle : Url -> String
getTitle url = 
  if String.startsWith "/about" url.path then 
    "About"
  else 
    "My Blog"

viewContent : Model -> Element Msg
viewContent model =
    Element.column [ Element.padding 22 ]
        [ viewLink "/about" "about"
        , viewLink "/" "home"
        , viewPage model
        , viewLink "https://www.duckduckgo.com" "DuckDuckGo"
        , viewLink "https://www.ecosia.org" "Ecosia"
        ]


viewPage : Model -> Element Msg
viewPage model =
    if model.url.path == "/about" then
        Element.map MsgAbout (About.view model.modelAboutPage)
    else
        Element.map MsgHome ( Home.view model.modelHomePage )


viewLink : String -> String -> Element msg
viewLink url caption = 
    Element.link [ Element.Font.color (Element.rgb255 0x11 0x55 0xFF)
    , Element.Font.underline
    , Element.Font.size 13 ] {
      url = url
      , label = Element.text caption
    }


-- UPDATE

type Msg
    = MsgUrlChanged Url
    | MsgUrlRequested Browser.UrlRequest
    | MsgAbout About.Msg
    | MsgHome Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgUrlChanged url -> 
          ( { model | url = url }, Cmd.none )

        MsgUrlRequested urlRequest ->
          case urlRequest of
              Browser.Internal url ->
                ( model
                , Nav.pushUrl model.navigationKey (Url.toString url) 
                )

              Browser.External url ->
                ( model, Nav.load url )
        
        MsgAbout msgAbout ->
          let 
             (newAboutPageModel, cmdAboutPage ) = 
              About.update msgAbout model.modelAboutPage
          in
          ( {model | modelAboutPage = newAboutPageModel } , Cmd.map MsgAbout cmdAboutPage )

        MsgHome msgHome ->
          let 
            ( newHomePageModel, cmdHomePage ) = 
                Home.update msgHome model.modelHomePage
          in
          ( {model | modelHomePage = newHomePageModel } , Cmd.map MsgHome cmdHomePage )




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [
    Sub.map MsgHome (Home.subscriptions model.modelHomePage)
    , Sub.map MsgAbout (About.subscriptions model.modelAboutPage)
  ]

-- URL HANDLING

onUrlChange : Url -> Msg
onUrlChange url =
    MsgUrlChanged url


onUrlRequest : UrlRequest -> Msg
onUrlRequest urlRequest =
    MsgUrlRequested urlRequest
